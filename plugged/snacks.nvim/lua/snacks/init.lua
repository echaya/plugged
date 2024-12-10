---@class Snacks: snacks.plugins
local M = {}

setmetatable(M, {
  __index = function(t, k)
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require("snacks." .. k)
    return rawget(t, k)
  end,
})

_G.Snacks = M

---@class snacks.Config.base
---@field example? string
---@field config? fun(opts: table, defaults: table)

---@class snacks.Config: snacks.plugins.Config
---@field styles? table<string, snacks.win.Config>
local config = {
  bigfile = { enabled = false },
  dashboard = { enabled = false },
  indent = { enabled = false },
  input = { enabled = false },
  notifier = { enabled = false },
  quickfile = { enabled = false },
  scroll = { enabled = false },
  statuscolumn = { enabled = false },
  styles = {},
  words = { enabled = false },
}

---@class snacks.config: snacks.Config
M.config = setmetatable({}, {
  __index = function(_, k)
    return config[k]
  end,
})

--- Get an example config from the docs/examples directory.
---@param snack string
---@param name string
---@param opts? table
function M.config.example(snack, name, opts)
  local path = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h") .. "/docs/examples/" .. snack .. ".lua"
  local ok, ret = pcall(function()
    return loadfile(path)().examples[name] or error(("`%s` not found"):format(name))
  end)
  if not ok then
    M.notify.error(("Failed to load `%s.%s`:\n%s"):format(snack, name, ret))
  end
  return ok and vim.tbl_deep_extend("force", {}, vim.deepcopy(ret), opts or {}) or {}
end

---@generic T: table
---@param snack string
---@param defaults T
---@param ... T[]
---@return T
function M.config.get(snack, defaults, ...)
  local merge, todo = {}, { defaults, config[snack], ... }
  for i = 1, select("#", ...) + 2 do
    local v = todo[i] --[[@as snacks.Config.base]]
    if type(v) == "table" then
      if v.example then
        table.insert(merge, vim.deepcopy(M.config.example(snack, v.example)))
        v.example = nil
      end
      table.insert(merge, vim.deepcopy(v))
    end
  end
  local ret = #merge == 1 and merge[1] or vim.tbl_deep_extend("force", unpack(merge)) --[[@as snacks.Config.base]]
  if type(ret.config) == "function" then
    ret.config(ret, defaults)
  end
  return ret
end

--- Register a new window style config.
---@param name string
---@param defaults snacks.win.Config
function M.config.style(name, defaults)
  config.styles[name] = vim.tbl_deep_extend("force", vim.deepcopy(defaults), config.styles[name] or {})
end

M.did_setup = false
M.did_setup_after_vim_enter = false

---@param opts snacks.Config?
function M.setup(opts)
  if M.did_setup then
    return vim.notify("snacks.nvim is already setup", vim.log.levels.ERROR, { title = "snacks.nvim" })
  end
  M.did_setup = true

  if vim.fn.has("nvim-0.9.4") ~= 1 then
    return vim.notify("snacks.nvim requires Neovim >= 0.9.4", vim.log.levels.ERROR, { title = "snacks.nvim" })
  end

  -- enable all by default when config is passed
  opts = opts or {}
  for k in pairs(opts) do
    opts[k].enabled = opts[k].enabled == nil or opts[k].enabled
  end
  config = vim.tbl_deep_extend("force", config, opts or {})

  local events = {
    BufReadPre = { "bigfile" },
    BufReadPost = { "quickfile", "indent" },
    LspAttach = { "words" },
    UIEnter = { "dashboard", "scroll" },
  }

  local function load(event)
    for _, snack in ipairs(events[event] or {}) do
      if M.config[snack] and M.config[snack].enabled then
        (M[snack].setup or M[snack].enable)()
      end
    end
    events[event] = nil
  end

  if vim.v.vim_did_enter == 1 then
    M.did_setup_after_vim_enter = true
    load("UIEnter")
  end

  vim.api.nvim_create_autocmd(vim.tbl_keys(events), {
    group = vim.api.nvim_create_augroup("snacks", { clear = true }),
    once = true,
    nested = true,
    callback = function(ev)
      load(ev.event)
    end,
  })

  if M.config.statuscolumn.enabled then
    vim.o.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
  end

  if M.config.input.enabled then
    vim.ui.input = function(...)
      return Snacks.input(...)
    end
  end

  if M.config.notifier.enabled then
    vim.notify = function(msg, level, o)
      vim.notify = Snacks.notifier.notify
      return Snacks.notifier.notify(msg, level, o)
    end
  end
end

return M
