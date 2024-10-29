local EntryMaker = require "frecency.entry_maker"
local State = require "frecency.state"
local Finder = require "frecency.finder"
local config = require "frecency.config"
local fs = require "frecency.fs"
local fuzzy_sorter = require "frecency.fuzzy_sorter"
local substr_sorter = require "frecency.substr_sorter"
local log = require "frecency.log"
local lazy_require = require "frecency.lazy_require"
local Path = lazy_require "plenary.path" --[[@as FrecencyPlenaryPath]]
local actions = lazy_require "telescope.actions"
local telescope_config = lazy_require "telescope.config"
local pickers = lazy_require "telescope.pickers"
local utils = lazy_require "telescope.utils" --[[@as FrecencyTelescopeUtils]]
local uv = vim.loop or vim.uv

---@class FrecencyPicker
---@field private config FrecencyPickerConfig
---@field private database FrecencyDatabase
---@field private entry_maker FrecencyEntryMaker
---@field private lsp_workspaces string[]
---@field private namespace integer
---@field private state FrecencyState
---@field private workspace string?
---@field private workspace_tag_regex string
local Picker = {}

---@class FrecencyPickerConfig
---@field editing_bufnr integer
---@field ignore_filenames? string[]
---@field initial_workspace_tag? string

---@class FrecencyPickerEntry
---@field display fun(entry: FrecencyPickerEntry): string
---@field filename string
---@field name string
---@field ordinal string
---@field score number

---@param database FrecencyDatabase
---@param picker_config FrecencyPickerConfig
---@return FrecencyPicker
Picker.new = function(database, picker_config)
  local self = setmetatable({
    config = picker_config,
    database = database,
    entry_maker = EntryMaker.new(),
    lsp_workspaces = {},
    namespace = vim.api.nvim_create_namespace "frecency",
  }, { __index = Picker })
  local d = config.filter_delimiter
  self.workspace_tag_regex = "^%s*" .. d .. "(%S+)" .. d
  return self
end

---@class FrecencyPickerOptions
---@field cwd string
---@field hide_current_buffer? boolean
---@field path_display
---| "hidden"
---| "tail"
---| "absolute"
---| "smart"
---| "shorten"
---| "truncate"
---| fun(opts: FrecencyPickerOptions, path: string): string
---@field workspace? string

---@param opts table
---@param workspace? string
---@param workspace_tag? string
function Picker:finder(opts, workspace, workspace_tag)
  local filepath_formatter = self:filepath_formatter(opts)
  local entry_maker = self.entry_maker:create(filepath_formatter, workspace, workspace_tag)
  local need_scandir = not not (workspace and config.show_unindexed)
  return Finder.new(
    self.database,
    entry_maker,
    need_scandir,
    workspace,
    self.state,
    { ignore_filenames = self.config.ignore_filenames }
  )
end

---@param opts? FrecencyPickerOptions
function Picker:start(opts)
  opts = vim.tbl_extend("force", {
    cwd = uv.cwd(),
    path_display = function(picker_opts, path)
      return self:default_path_display(picker_opts, path)
    end,
  }, telescope_config.values, opts or {}) --[[@as FrecencyPickerOptions]]
  self.workspace = self:get_workspace(opts.cwd, self.config.initial_workspace_tag or config.default_workspace)
  log.debug { workspace = self.workspace }

  self.state = State.new()
  local finder = self:finder(opts, self.workspace, self.config.initial_workspace_tag or config.default_workspace)
  local picker = pickers.new(opts, {
    prompt_title = "Frecency",
    finder = finder,
    previewer = telescope_config.values.file_previewer(opts),
    sorter = config.matcher == "default" and substr_sorter() or fuzzy_sorter(opts),
    on_input_filter_cb = self:on_input_filter_cb(opts),
    attach_mappings = function(prompt_bufnr)
      return self:attach_mappings(prompt_bufnr)
    end,
  })
  self.state:set(picker)
  picker:find()
  finder:start()
  self:set_prompt_options(picker.prompt_bufnr)
end

--- See :h 'complete-functions'
---@param findstart 1|0
---@param base string
---@return integer|string[]|''
function Picker:complete(findstart, base)
  if findstart == 1 then
    local line = vim.api.nvim_get_current_line()
    local start = line:find(config.filter_delimiter)
    -- don't complete if there's already a completed `:tag:` in line
    if not start or line:find(config.filter_delimiter, start + 1) then
      return -3
    end
    return start
  elseif vim.fn.pumvisible() == 1 and #vim.v.completed_item > 0 then
    return ""
  end
  ---@param v string
  local matches = vim.tbl_filter(function(v)
    return vim.startswith(v, base)
  end, self:workspace_tags())
  return #matches > 0 and matches or ""
end

---@private
---@return string[]
function Picker:workspace_tags()
  local tags = vim.tbl_keys(config.workspaces)
  table.insert(tags, "CWD")
  if self:get_lsp_workspace() then
    table.insert(tags, "LSP")
  end
  return tags
end

---@private
---@param opts FrecencyPickerOptions
---@param path string
---@return string
function Picker:default_path_display(opts, path)
  local filename = Path:new(path):make_relative(opts.cwd)
  if not self.workspace then
    if vim.startswith(filename, fs.os_homedir) then
      filename = "~" .. Path.path.sep .. fs.relative_from_home(filename)
    elseif filename ~= path then
      filename = "." .. Path.path.sep .. filename
    end
  end
  return filename
end

---@private
---@param cwd string
---@param tag? string
---@return string?
function Picker:get_workspace(cwd, tag)
  if not tag then
    return nil
  elseif config.workspaces[tag] then
    return config.workspaces[tag]
  elseif tag == "LSP" then
    return self:get_lsp_workspace()
  elseif tag == "CWD" then
    return cwd
  end
end

---@private
---@return string?
function Picker:get_lsp_workspace()
  if vim.tbl_isempty(self.lsp_workspaces) then
    self.lsp_workspaces = vim.api.nvim_buf_call(self.config.editing_bufnr, vim.lsp.buf.list_workspace_folders)
  end
  return self.lsp_workspaces[1]
end

---@private
---@param picker_opts table
---@return fun(prompt: string): table
function Picker:on_input_filter_cb(picker_opts)
  return function(prompt)
    local workspace
    local start, finish, tag = prompt:find(self.workspace_tag_regex)
    local opts = { prompt = start and prompt:sub(finish + 1) or prompt }
    if prompt == "" then
      workspace = self:get_workspace(picker_opts.cwd, self.config.initial_workspace_tag or config.default_workspace)
    else
      workspace = self:get_workspace(picker_opts.cwd, tag) or self.workspace
    end
    local picker = self.state:get()
    if picker then
      local buf = picker.prompt_bufnr
      vim.api.nvim_buf_clear_namespace(buf, self.namespace, 0, -1)
      if start then
        local prefix = picker.prompt_prefix
        local start_col = #prefix + start - 1
        local end_col = #prefix + finish
        vim.api.nvim_buf_set_extmark(
          buf,
          self.namespace,
          0,
          start_col,
          { end_row = 0, end_col = end_col, hl_group = "TelescopeQueryFilter" }
        )
      end
    end
    if self.workspace ~= workspace then
      self.workspace = workspace
      opts.updated_finder =
        self:finder(picker_opts, self.workspace, tag or self.config.initial_workspace_tag or config.default_workspace)
      opts.updated_finder:start()
    end
    return opts
  end
end

---@private
---@param _ integer
---@return boolean
function Picker:attach_mappings(_)
  actions.select_default:replace_if(function()
    return vim.fn.complete_info().pum_visible == 1
  end, function()
    local keys = vim.fn.complete_info().selected == -1 and "<C-e><BS><Right>" or "<C-y><Right>:"
    local accept_completion = vim.api.nvim_replace_termcodes(keys, true, false, true)
    vim.api.nvim_feedkeys(accept_completion, "n", true)
  end)
  return true
end

---@private
---@param bufnr integer
---@return nil
function Picker:set_prompt_options(bufnr)
  vim.bo[bufnr].completefunc = "v:lua.require'telescope'.extensions.frecency.complete"
  vim.keymap.set("i", "<Tab>", "pumvisible() ? '<C-n>' : '<C-x><C-u>'", { buffer = bufnr, expr = true })
  vim.keymap.set("i", "<S-Tab>", "pumvisible() ? '<C-p>' : ''", { buffer = bufnr, expr = true })
end

---@alias FrecencyFilepathFormatter fun(workspace: string?): fun(filename: string): string, FrecencyTelescopePathStyle[]

---@private
---@param picker_opts table
---@return FrecencyFilepathFormatter
function Picker:filepath_formatter(picker_opts)
  ---@param workspace string?
  return function(workspace)
    local opts = {}
    for k, v in pairs(picker_opts) do
      opts[k] = v
    end
    opts.cwd = workspace or fs.os_homedir

    return function(filename)
      return utils.transform_path(opts, filename)
    end
  end
end

return Picker
