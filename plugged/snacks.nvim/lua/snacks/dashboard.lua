---@class snacks.dashboard
---@overload fun(opts?: snacks.dashboard.Opts): snacks.dashboard.Class
local M = setmetatable({}, {
  __call = function(M, opts)
    return M.open(opts)
  end,
})

local uv = vim.uv or vim.loop
math.randomseed(os.time())

---@class snacks.dashboard.Item
---@field indent? number
---@field align? "left" | "center" | "right"
---@field gap? number the number of empty lines between child items
---@field padding? number | {[1]:number, [2]:number} bottom or {bottom, top} padding
--- The action to run when the section is selected or the key is pressed.
--- * if it's a string starting with `:`, it will be run as a command
--- * if it's a string, it will be executed as a keymap
--- * if it's a function, it will be called
---@field action? snacks.dashboard.Action
---@field enabled? boolean|fun(opts:snacks.dashboard.Opts):boolean if false, the section will be disabled
---@field section? string the name of a section to include. See `Snacks.dashboard.sections`
---@field [string] any section options
---@field key? string shortcut key
---@field autokey? boolean automatically assign a numerical key
---@field label? string
---@field desc? string
---@field file? string
---@field footer? string
---@field header? string
---@field icon? string
---@field title? string
---@field text? string|snacks.dashboard.Text[]

---@alias snacks.dashboard.Format.ctx {width?:number}
---@alias snacks.dashboard.Action string|fun(self:snacks.dashboard.Class)
---@alias snacks.dashboard.Gen fun(self:snacks.dashboard.Class):snacks.dashboard.Section?
---@alias snacks.dashboard.Section snacks.dashboard.Item|snacks.dashboard.Gen|snacks.dashboard.Section[]

---@class snacks.dashboard.Text
---@field [1] string the text
---@field hl? string the highlight group
---@field width? number the width used for alignment
---@field align? "left" | "center" | "right"

---@private
---@class snacks.dashboard.Item
---@field package _? snacks.dashboard.Item._ the position of the item in the dashboard

---@private
---@class snacks.dashboard.Item._
---@field pane number 1-indexed
---@field row number 1-indexed
---@field col number 0-indexed

---@private
---@class snacks.dashboard.Line
---@field [number] snacks.dashboard.Text
---@field width number

---@private
---@class snacks.dashboard.Block
---@field [number] snacks.dashboard.Line
---@field width number

---@class snacks.dashboard.Config
---@field sections snacks.dashboard.Section
---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>
local defaults = {
  width = 60,
  row = nil, -- dashboard position. nil for center
  col = nil, -- dashboard position. nil for center
  pane_gap = 4, -- empty columns between vertical panes
  autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
  -- These settings are used by some built-in sections
  preset = {
    -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
    ---@type fun(cmd:string, opts:table)|nil
    pick = nil,
    -- Used by the `keys` section to show keymaps.
    -- Set your curstom keymaps here.
    -- When using a function, the `items` argument are the default keymaps.
    -- stylua: ignore
    ---@type snacks.dashboard.Item[]
    keys = {
      { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
      { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
      { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
      { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
      { icon = " ", key = "s", desc = "Restore Session", section = "session" },
      { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
      { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    },
    -- Used by the `header` section
    header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
  },
  -- item field formatters
  formats = {
    icon = function(item)
      if item.file and item.icon == "file" or item.icon == "directory" then
        return M.icon(item.file, item.icon)
      end
      return { item.icon, width = 2, hl = "icon" }
    end,
    footer = { "%s", align = "center" },
    header = { "%s", align = "center" },
    file = function(item, ctx)
      local fname = vim.fn.fnamemodify(item.file, ":~")
      fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
      local dir, file = fname:match("^(.*)/(.+)$")
      return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
    end,
  },
  sections = {
    { section = "header" },
    { section = "keys", gap = 1, padding = 1 },
    { section = "startup" },
  },
  debug = false,
}

-- The default style for the dashboard.
-- When opening the dashboard during startup, only the `bo` and `wo` options are used.
-- The other options are used with `:lua Snacks.dashboard()`
Snacks.config.style("dashboard", {
  zindex = 10,
  height = 0,
  width = 0,
  bo = {
    bufhidden = "wipe",
    buftype = "nofile",
    filetype = "snacks_dashboard",
    swapfile = false,
    undofile = false,
  },
  wo = {
    colorcolumn = "",
    cursorcolumn = false,
    cursorline = false,
    list = false,
    number = false,
    relativenumber = false,
    sidescrolloff = 0,
    signcolumn = "no",
    spell = false,
    statuscolumn = "",
    statusline = "",
    winbar = "",
    winhighlight = "Normal:SnacksDashboardNormal,NormalFloat:SnacksDashboardNormal",
    wrap = false,
  },
})

M.ns = vim.api.nvim_create_namespace("snacks_dashboard")

local links = {
  Desc = "Special",
  File = "Special",
  Dir = "NonText",
  Footer = "Title",
  Header = "Title",
  Icon = "Special",
  Key = "Number",
  Normal = "Normal",
  Terminal = "SnacksDashboardNormal",
  Special = "Special",
  Title = "Title",
}
local hl_groups = {} ---@type table<string, string>
for group in pairs(links) do
  hl_groups[group:lower()] = "SnacksDashboard" .. group
end
Snacks.util.set_hl(links, { prefix = "SnacksDashboard", default = true })

---@class snacks.dashboard.Opts: snacks.dashboard.Config
---@field buf? number the buffer to use. If not provided, a new buffer will be created
---@field win? number the window to use. If not provided, a new floating window will be created

---@class snacks.dashboard.Class
---@field opts snacks.dashboard.Opts
---@field buf number
---@field win number
---@field _size? {width:number, height:number}
---@field items snacks.dashboard.Item[]
---@field row? number
---@field col? number
---@field panes? snacks.dashboard.Item[][]
---@field lines? string[]
---@field augroup integer
local D = {}

---@param opts? snacks.dashboard.Opts
---@return snacks.dashboard.Class
function M.open(opts)
  local self = setmetatable({}, { __index = D })
  self.opts = Snacks.config.get("dashboard", defaults, opts) --[[@as snacks.dashboard.Opts]]
  self.buf = self.opts.buf or vim.api.nvim_create_buf(false, true)
  self.win = self.opts.win or Snacks.win({ style = "dashboard", buf = self.buf, enter = true }).win --[[@as number]]
  self.augroup = vim.api.nvim_create_augroup("snacks_dashboard", { clear = true })
  self:init()
  self:update()
  self.fire("Opened")
  return self
end

---@param name? string
function D:trace(name)
  return self.opts.debug and Snacks.debug.trace(name and ("dashboard:" .. name) or nil)
end

function D:init()
  vim.api.nvim_win_set_buf(self.win, self.buf)
  vim.o.ei = "all"
  Snacks.util.wo(self.win, Snacks.config.styles.dashboard.wo)
  Snacks.util.bo(self.buf, Snacks.config.styles.dashboard.bo)
  vim.o.ei = ""
  if self:is_float() then
    vim.keymap.set("n", "<esc>", "<cmd>bd<cr>", { silent = true, buffer = self.buf })
  end
  vim.keymap.set("n", "q", "<cmd>bd<cr>", { silent = true, buffer = self.buf })
  vim.api.nvim_create_autocmd("WinResized", {
    group = self.augroup,
    buffer = self.buf,
    callback = function(ev)
      -- only re-render if the same window and size has changed
      if tonumber(ev.match) == self.win and not vim.deep_equal(self._size, self:size()) then
        self:update()
      end
    end,
  })
  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = self.buf,
    callback = function()
      self.fire("Closed")
      vim.api.nvim_del_augroup_by_id(self.augroup)
    end,
  })
  self.on("Update", function()
    self:update()
  end, self.augroup)
end

---@return {width:number, height:number}
function D:size()
  return {
    width = vim.api.nvim_win_get_width(self.win),
    height = vim.api.nvim_win_get_height(self.win) + (vim.o.laststatus >= 2 and 1 or 0),
  }
end

function D:is_float()
  return vim.api.nvim_win_get_config(self.win).relative ~= ""
end

---@param action snacks.dashboard.Action
function D:action(action)
  -- close the window before running the action if it's floating
  if self:is_float() then
    vim.api.nvim_win_close(self.win, true)
    self.win = nil
  end
  vim.schedule(function()
    if type(action) == "string" then
      if action:find("^:") then
        return vim.cmd(action:sub(2))
      else
        local keys = vim.api.nvim_replace_termcodes(action, true, true, true)
        return vim.api.nvim_feedkeys(keys, "tm", true)
      end
    end
    action(self)
  end)
end

---@param item snacks.dashboard.Item
---@param field string
---@param width? number
---@return snacks.dashboard.Text|snacks.dashboard.Text[]
function D:format_field(item, field, width)
  if type(item[field]) == "table" then
    return item[field]
  end
  local format = self.opts.formats[field]
  if format == nil then
    return { item[field], hl = field }
  elseif type(format) == "function" then
    return format(item, { width = width })
  else
    local text = format and vim.deepcopy(format) or { "%s" }
    text.hl = text.hl or field
    text[1] = text[1] == "%s" and item[field] or text[1]:format(item[field])
    return text
  end
end

---@param item snacks.dashboard.Text|snacks.dashboard.Line
---@param width? number
---@param align? "left"|"center"|"right"
function D:align(item, width, align)
  local len = 0
  if type(item[1]) == "string" then ---@cast item snacks.dashboard.Text
    width, align, len = width or item.width, align or item.align, vim.api.nvim_strwidth(item[1])
  else ---@cast item snacks.dashboard.Line
    if #item == 1 then -- only one text, so align that instead
      self:align(item[1], width, align)
      item.width = item[1].width
      return
    end
    len = item.width
  end

  if not width or width <= 0 or width == len then
    item.width = math.max(width or 0, len)
    return
  end

  align = align or "left"
  local before = align == "center" and math.floor((width - len) / 2) or align == "right" and width - len or 0
  local after = align == "center" and width - len - before or align == "left" and width - len or 0

  if type(item[1]) == "string" then ---@cast item snacks.dashboard.Text
    item[1] = (" "):rep(before) .. item[1] .. (" "):rep(after)
    item.width = math.max(width, len)
  else ---@cast item snacks.dashboard.Line
    if before > 0 then
      table.insert(item, 1, { (" "):rep(before) })
    end
    if after > 0 then
      table.insert(item, { (" "):rep(after) })
    end
    item.width = math.max(width, len)
  end
end

---@param texts snacks.dashboard.Text[]|snacks.dashboard.Text|string
function D:texts(texts)
  texts = type(texts) == "string" and { { texts } } or texts
  texts = type(texts[1]) == "string" and { texts } or texts
  return texts --[[ @as snacks.dashboard.Text[] ]]
end

--- Create a block from a list of texts (possibly with newlines)
---@param texts snacks.dashboard.Text[]
function D:block(texts)
  local ret = { { width = 0 }, width = 0 } ---@type snacks.dashboard.Block
  for _, text in ipairs(texts) do
    -- PERF: only split lines when needed
    local lines = text[1]:find("\n", 1, true) and vim.split(text[1], "\n", { plain = true }) or { text[1] }
    for l, line in ipairs(lines) do
      if l > 1 then
        ret[#ret + 1] = { width = 0 }
      end
      local child = setmetatable({ line }, { __index = text })
      self:align(child)
      ret[#ret].width = ret[#ret].width + vim.api.nvim_strwidth(child[1])
      ret.width = math.max(ret.width, ret[#ret].width)
      table.insert(ret[#ret], child)
    end
  end
  return ret
end

---@param item snacks.dashboard.Item
function D:format(item)
  local width = item.indent or 0

  ---@param fields string[]
  ---@param opts {align?:"left"|"center"|"right", padding?:number, flex?:boolean, multi?:boolean}
  local function find(fields, opts)
    local flex = opts.flex and math.max(0, self.opts.width - width) or nil
    local texts = {} ---@type snacks.dashboard.Text[]
    for _, k in ipairs(fields) do
      if item[k] then
        vim.list_extend(texts, self:texts(self:format_field(item, k, flex)))
        if not opts.multi then
          break
        end
      end
    end
    if #texts == 0 then
      return { width = 0 }
    end
    local block = self:block(texts)
    block.width = block.width + (opts.padding or 0)
    width = width + block.width
    return block
  end

  local block = item.text and self:block(self:texts(item.text))
  local left = block and { width = 0 } or find({ "icon" }, { align = "left", padding = 1 })
  local right = block and { width = 0 } or find({ "label", "key" }, { align = "right", padding = 1 })
  local center = block or find({ "header", "footer", "title", "desc", "file" }, { flex = true, multi = true })

  local padding = self:padding(item)
  local ret = { width = self.opts.width } ---@type snacks.dashboard.Block
  for l = 1, math.max(#left, #center, #right, 1) + padding[1] do
    ret[l] = { width = 0 }
    left[l] = left[l] or { width = 0 }
    right[l] = right[l] or { width = 0 }
    center[l] = center[l] or { width = 0 }
    self:align(left[l], left.width, "left")
    if item.indent then
      self:align(left[l], left[l].width + item.indent, "right")
    end
    self:align(right[l], right.width, "right")
    self:align(center[l], self.opts.width - left[l].width - right[l].width, item.align)
    vim.list_extend(ret[l], left[l])
    vim.list_extend(ret[l], center[l])
    vim.list_extend(ret[l], right[l])
    ret[l].width = left[l].width + center[l].width + right[l].width
  end
  for _ = 1, padding[2] do
    table.insert(ret, 1, { width = self.opts.width })
  end
  return ret
end

---@param item snacks.dashboard.Item
function D:enabled(item)
  local e = item.enabled
  if type(e) == "function" then
    return e(self.opts)
  end
  return e == nil or e
end

---@param item snacks.dashboard.Section?
---@param results? snacks.dashboard.Item[]
---@param parent? snacks.dashboard.Item
function D:resolve(item, results, parent)
  results = results or {}
  if not item then
    return results
  end
  if type(item) == "table" and parent then -- inherit parent properties
    for _, prop in ipairs({ "indent", "align", "pane" }) do
      item[prop] = item[prop] or parent[prop]
    end
  end

  if type(item) == "function" then
    return self:resolve(item(self), results, parent)
  elseif type(item) == "table" and self:enabled(item) then
    if not item.section and not item[1] then
      table.insert(results, item)
      return results
    end
    local first_child = #results + 1
    if item.title then -- always add the title
      table.insert(results, { title = item.title, icon = item.icon, pane = item.pane })
    end
    if item.section then -- add section items
      self:trace("resolve." .. item.section)
      local items = M.sections[item.section](item) ---@type snacks.dashboard.Section?
      self:resolve(items, results, item)
      self:trace()
    end
    if item[1] then -- add child items
      for _, child in ipairs(item) do
        self:resolve(child, results, item)
      end
    end
    if item.gap then -- add padding between child items
      for i = first_child, #results - 1 do
        results[i].padding = item.gap
      end
    end
    if item.padding then -- add padding to the first and last child items
      local padding = self:padding(item)
      if padding[2] > 0 and results[first_child] then
        results[first_child].padding = { 0, padding[2] }
      end
      if padding[1] > 0 and results[#results] then
        results[#results].padding = { padding[1], 0 }
      end
    end
  elseif type(item) ~= "table" then
    Snacks.notify.error("Invalid item:\n```lua\n" .. vim.inspect(item) .. "\n```", { title = "Dashboard" })
  end
  return results
end

---@return {[1]: number, [2]: number}
function D:padding(item)
  return item.padding and (type(item.padding) == "table" and item.padding or { item.padding, 0 }) or { 0, 0 }
end

function D.fire(event)
  vim.api.nvim_exec_autocmds("User", { pattern = "SnacksDashboard" .. event, modeline = false })
end

---@param event string|string[]
---@param cb fun()
---@param group? string|integer
function D.on(event, cb, group)
  vim.api.nvim_create_autocmd("User", { pattern = "SnacksDashboard" .. event, callback = cb, group = group })
end

---@param pos {[1]:number, [2]:number}
---@param from? {[1]:number, [2]:number}
function D:find(pos, from)
  from = from or pos
  local line = self.lines[pos[1]]
  local char = vim.fn.charidx(line, pos[2]) -- map col to charachter index

  local pane = math.floor((char - self.col) / (self.opts.width + self.opts.pane_gap)) + 1
  pane = math.max(1, math.min(pane, #self.panes))
  if pos[1] == from[1] then
    if pos[2] == from[2] - 1 then
      pane = pane - 1
    elseif pos[2] == from[2] + 1 then
      pane = pane + 1
    end
  end
  pane = math.max(1, math.min(pane, #self.panes))

  local ret ---@type snacks.dashboard.Item?
  for _, item in ipairs(self.items) do
    if item._.pane == pane and item.action then
      if ret and pos[1] < from[1] and item._.row > pos[1] then
        break
      end
      ret = item
      if pos[1] >= from[1] and item._.row >= pos[1] then
        break
      end
    end
  end
  return ret
end

-- Layout in panes
function D:layout()
  local max_panes =
    math.max(1, math.floor((self._size.width + self.opts.pane_gap) / (self.opts.width + self.opts.pane_gap)))
  self.panes = {} ---@type snacks.dashboard.Item[][]
  for _, item in ipairs(self.items) do
    local pane = item.pane or 1
    pane = math.fmod(pane - 1, max_panes) + 1 -- distribute panes evenly
    self.panes[pane] = self.panes[pane] or {}
    table.insert(self.panes[pane], item)
  end
  for p = 1, math.max(unpack(vim.tbl_keys(self.panes))) or 1 do
    self.panes[p] = self.panes[p] or {}
  end
end

-- Format and render the dashboard
function D:render()
  -- horizontal position
  self.col = self.opts.col
    or math.floor(self._size.width - (self.opts.width * #self.panes + self.opts.pane_gap * (#self.panes - 1))) / 2

  self.lines = {} ---@type string[]
  local extmarks = {} ---@type {row:number, col:number, opts:vim.api.keyset.set_extmark}[]
  for p, pane in ipairs(self.panes) do
    local indent = (" "):rep(p == 1 and self.col or self.opts.pane_gap)
    local row = 0
    for _, item in ipairs(pane or {}) do
      for l, line in ipairs(self:format(item)) do
        row = row + 1
        if p > 1 and not self.lines[row] then -- add lines for empty panes
          self.lines[row] = (" "):rep(self.col + (self.opts.width + self.opts.pane_gap) * (p - 1))
        elseif p == 1 and line.width > self.opts.width then
          self.lines[row] = (" "):rep(self.col - math.floor((line.width - self.opts.width) / 2))
        else
          self.lines[row] = (self.lines[row] or "") .. indent
        end
        if l == 1 then
          item._ = { pane = p, row = row, col = #self.lines[row] - 1 }
        end
        ---@cast line snacks.dashboard.Line
        for _, text in ipairs(line) do
          self.lines[row] = self.lines[row] .. text[1]
          if text.hl then
            table.insert(extmarks, {
              row = row - 1,
              col = #self.lines[row] - #text[1],
              opts = { hl_group = hl_groups[text.hl] or text.hl, end_col = #self.lines[row] },
            })
          end
        end
      end
    end
  end

  -- vertical position
  self.row = self.opts.row or math.max(math.floor((self._size.height - #self.lines) / 2), 0)
  for _ = 1, self.row do
    table.insert(self.lines, 1, "")
  end

  -- fix item positions
  for _, item in ipairs(self.items) do
    if item._ then
      item._.row = item._.row + self.row
      if item.render then
        item.render(self, { item._.row, item._.col })
      end
    end
  end

  self:render_buf(extmarks)
end

---@param extmarks {row:number, col:number, opts:vim.api.keyset.set_extmark}[]
function D:render_buf(extmarks)
  -- set lines
  vim.bo[self.buf].modifiable = true
  vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, self.lines)
  vim.bo[self.buf].modifiable = false

  -- extmarks
  vim.api.nvim_buf_clear_namespace(self.buf, M.ns, 0, -1)
  for _, extmark in ipairs(extmarks) do
    vim.api.nvim_buf_set_extmark(self.buf, M.ns, extmark.row + self.row, extmark.col, extmark.opts)
  end
end

function D:keys()
  local autokeys = self.opts.autokeys:gsub("[hjklq]", "")
  for _, item in ipairs(self.items) do
    if item.key and not item.autokey then
      autokeys = autokeys:gsub(vim.pesc(item.key), "", 1)
    end
  end
  for _, item in ipairs(self.items) do
    if item.autokey then
      item.key, autokeys = autokeys:sub(1, 1), autokeys:sub(2)
    end
    if item.key then
      vim.keymap.set("n", item.key, function()
        self:action(item.action)
      end, { buffer = self.buf, nowait = not item.autokey, desc = "Dashboard action" })
    end
  end
end

function D:update()
  self.fire("UpdatePre")
  self._size = self:size()

  self.items = self:resolve(self.opts.sections)

  self:layout()
  self:keys()
  self:render()

  -- actions on enter
  vim.keymap.set("n", "<cr>", function()
    local item = self:find(vim.api.nvim_win_get_cursor(self.win))
    return item and item.action and self:action(item.action)
  end, { buffer = self.buf, nowait = true, desc = "Dashboard action" })

  -- cursor movement
  local last = { 1, 0 }
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = vim.api.nvim_create_augroup("snacks_dashboard_cursor", { clear = true }),
    buffer = self.buf,
    callback = function()
      local item = self:find(vim.api.nvim_win_get_cursor(self.win), last)
      if not item then -- can happen for panes without actionable items
        for _, it in ipairs(self.items) do
          if it.action then
            item = it
            break
          end
        end
      end
      if item then
        last = { item._.row, (self.lines[item._.row]:find("[%w%d%p]", item._.col + 1) or item._.col + 1) - 1 }
      end
      vim.api.nvim_win_set_cursor(self.win, last)
    end,
  })
  self.fire("UpdatePost")
end

-- Get an icon
---@param name string
---@param cat? string
---@return snacks.dashboard.Text
function M.icon(name, cat)
  -- stylua: ignore
  local try = {
    function() return require("mini.icons").get(cat or "file", name) end,
    function() return require("nvim-web-devicons").get_icon(name) end,
  }
  for _, fn in ipairs(try) do
    local ok, icon, hl = pcall(fn)
    if ok then
      return { icon, hl = hl, width = 2 }
    end
  end
  return { " ", hl = "icon", width = 2 }
end

-- Used by the default preset to pick something
---@param cmd? string
function M.pick(cmd, opts)
  cmd = cmd or "files"
  local config = Snacks.config.get("dashboard", defaults, opts)
  -- stylua: ignore
  local try = {
    function() return config.preset.pick(cmd, opts) end,
    function() return require("fzf-lua")[cmd](opts) end,
    function() return require("telescope.builtin")[cmd == "files" and "find_files" or cmd](opts) end,
    function() return require("mini.pick").builtin[cmd](opts) end,
  }
  for _, fn in ipairs(try) do
    if pcall(fn) then
      return
    end
  end
  Snacks.notify.error("No picker found for " .. cmd)
end

-- Checks if the plugin is installed.
-- Only works with [lazy.nvim](https://github.com/folke/lazy.nvim)
---@param name string
function M.have_plugin(name)
  return package.loaded.lazy and require("lazy.core.config").spec.plugins[name] ~= nil
end

M.sections = {}

-- Adds a section to restore the session if any of the supported plugins are installed.
---@param item? snacks.dashboard.Item
---@return snacks.dashboard.Item?
function M.sections.session(item)
  local plugins = {
    { "persistence.nvim", ":lua require('persistence').load()" },
    { "persisted.nvim", ":lua require('persisted').load()" },
    { "neovim-session-manager", ":SessionManager load_current_dir_session" },
    { "possession.nvim", ":PossessionLoadCwd" },
    { "mini.sessions", ":lua require('mini.sessions').read('local')" },
    { "mini.nvim", ":lua require('mini.sessions').read('local')" },
  }
  for _, plugin in pairs(plugins) do
    if M.have_plugin(plugin[1]) then
      return setmetatable({ -- add the action and disable the section
        action = plugin[2],
        section = false,
      }, { __index = item })
    end
  end
end

--- Get the most recent files, optionally filtered by the
--- current working directory or a custom directory.
---@param opts? {limit?:number, cwd?:string|boolean}
---@return snacks.dashboard.Gen
function M.sections.recent_files(opts)
  return function()
    opts = opts or {}
    local limit = opts.limit or 5
    local root = opts.cwd and vim.fs.normalize(opts.cwd == true and vim.fn.getcwd() or opts.cwd) or ""
    local ret = {} ---@type snacks.dashboard.Section
    for _, file in ipairs(vim.v.oldfiles) do
      file = vim.fs.normalize(file, { _fast = true, expand_env = false })
      if file:sub(1, #root) == root and uv.fs_stat(file) then
        ret[#ret + 1] = {
          file = file,
          icon = "file",
          action = ":e " .. file,
          autokey = true,
        }
        if #ret >= limit then
          break
        end
      end
    end
    return ret
  end
end

--- Get the most recent projects based on git roots of recent files.
--- The default action will change the directory to the project root,
--- try to restore the session and open the picker if the session is not restored.
--- You can customize the behavior by providing a custom action.
--- Use `opts.dirs` to provide a list of directories to use instead of the git roots.
---@param opts? {limit?:number, dirs?:(string[]|fun():string[]), pick?:boolean, session?:boolean, action?:fun(dir)}
function M.sections.projects(opts)
  opts = vim.tbl_extend("force", { pick = true, session = true }, opts or {})
  local limit = opts.limit or 5
  local dirs = opts.dirs or {}
  dirs = type(dirs) == "function" and dirs() or dirs --[[ @as string[] ]]
  dirs = vim.list_slice(dirs, 1, limit)

  if not opts.dirs then
    for _, file in ipairs(vim.v.oldfiles) do
      file = vim.fs.normalize(file, { _fast = true, expand_env = false })
      local dir = uv.fs_stat(file) and Snacks.git.get_root(file)
      if dir and not vim.tbl_contains(dirs, dir) then
        table.insert(dirs, dir)
        if #dirs >= limit then
          break
        end
      end
    end
  end

  local ret = {} ---@type snacks.dashboard.Item[]
  for _, dir in ipairs(dirs) do
    ret[#ret + 1] = {
      file = dir,
      icon = "directory",
      action = function(self)
        if opts.action then
          return opts.action(dir)
        end
        -- stylua: ignore
        if opts.session then
          local session_loaded = false
          vim.api.nvim_create_autocmd("SessionLoadPost", { once = true, callback = function() session_loaded = true end })
          vim.defer_fn(function() if not session_loaded and opts.pick then M.pick() end end, 100)
        end
        vim.fn.chdir(dir)
        local session = M.sections.session()
        if opts.session and session then
          self:action(session.action)
        elseif opts.pick then
          M.pick()
        end
      end,
      autokey = true,
    }
  end
  return ret
end

---@return snacks.dashboard.Gen
function M.sections.header()
  return function(self)
    return { header = self.opts.preset.header, padding = 2 }
  end
end

---@return snacks.dashboard.Gen
function M.sections.keys()
  return function(self)
    return vim.deepcopy(self.opts.preset.keys)
  end
end

---@param opts {cmd:string|string[], ttl?:number, height?:number, width?:number, random?:number}|snacks.dashboard.Item
---@return snacks.dashboard.Gen
function M.sections.terminal(opts)
  return function(self)
    local cmd = opts.cmd or 'echo "No `cmd` provided"'
    local ttl = opts.ttl or 3600
    local width, height = opts.width or self.opts.width, opts.height or 10

    local cache_parts = {
      table.concat(type(cmd) == "table" and cmd or { cmd }, " "),
      uv.cwd(),
      opts.random and math.random(1, opts.random) or "",
      "txt",
    }
    local cache_dir = vim.fn.stdpath("cache") .. "/snacks"
    local cache_file = cache_dir .. "/" .. table.concat(cache_parts, "."):gsub("[^%w%-_%.]", "_")
    local stat = uv.fs_stat(cache_file)
    local buf = vim.api.nvim_create_buf(false, true)
    local chan = vim.api.nvim_open_term(buf, {})

    local function send(data)
      vim.api.nvim_chan_send(chan, data)
      -- HACK: this forces a refresh of the terminal buffer and prevents flickering
      vim.bo[buf].scrollback = 9999
      vim.bo[buf].scrollback = 9998
    end

    local jid, stopped ---@type number?, boolean?
    if stat and stat.type == "file" and stat.size > 0 and os.time() - stat.mtime.sec < ttl then
      local fin = assert(uv.fs_open(cache_file, "r", 438))
      send(uv.fs_read(fin, stat.size, 0) or "")
      uv.fs_close(fin)
    else
      local output, recording = {}, uv.new_timer()
      -- record output for max 3 seconds. otherwise assume its streaming
      recording:start(3000, 0, function()
        output = {}
      end)
      jid = vim.fn.jobstart(cmd, {
        height = height,
        width = width,
        pty = true,
        on_stdout = function(_, data)
          data = table.concat(data, "\n")
          if recording:is_active() then
            table.insert(output, data)
          end
          pcall(send, data)
        end,
        on_exit = function(_, code)
          if not recording:is_active() or stopped then
            return
          end
          if code ~= 0 then
            Snacks.notify.error(
              ("Terminal **cmd** `%s` failed with code `%d`:\n- `vim.o.shell = %q`\n\nOutput:\n%s"):format(
                cmd,
                code,
                vim.o.shell,
                vim.trim(table.concat(output, ""))
              )
            )
          elseif ttl > 0 then -- save the output
            vim.fn.mkdir(cache_dir, "p")
            local fout = assert(uv.fs_open(cache_file, "w", 438))
            uv.fs_write(fout, table.concat(output, ""))
            uv.fs_close(fout)
          end
        end,
      })
      if jid <= 0 then
        Snacks.notify.error(("Failed to start terminal **cmd** `%s`"):format(cmd))
      end
    end
    return {
      render = function(_, pos)
        self:trace("terminal.render")
        local win = vim.api.nvim_open_win(buf, false, {
          bufpos = { pos[1] - 1, pos[2] + 1 },
          col = opts.indent or 0,
          focusable = false,
          height = height,
          noautocmd = true,
          relative = "win",
          row = 0,
          zindex = Snacks.config.styles.dashboard.zindex + 1,
          style = "minimal",
          width = width,
          win = self.win,
        })
        local hl = opts.hl and hl_groups[opts.hl] or opts.hl or "SnacksDashboardTerminal"
        Snacks.util.wo(win, { winhighlight = "TermCursorNC:" .. hl .. ",NormalFloat:" .. hl })
        local close = vim.schedule_wrap(function()
          stopped = true
          pcall(vim.api.nvim_win_close, win, true)
          pcall(vim.api.nvim_buf_delete, buf, { force = true })
          pcall(vim.fn.jobstop, jid)
          return true
        end)
        self.on("UpdatePre", close)
        self.on("Closed", close)
        self:trace()
      end,
      text = ("\n"):rep(height - 1),
    }
  end
end

--- Add the startup section
---@return snacks.dashboard.Section?
function M.sections.startup()
  M.lazy_stats = M.lazy_stats and M.lazy_stats.startuptime > 0 and M.lazy_stats or require("lazy.stats").stats()
  local ms = (math.floor(M.lazy_stats.startuptime * 100 + 0.5) / 100)
  return {
    align = "center",
    text = {
      { "⚡ Neovim loaded ", hl = "footer" },
      { M.lazy_stats.loaded .. "/" .. M.lazy_stats.count, hl = "special" },
      { " plugins in ", hl = "footer" },
      { ms .. "ms", hl = "special" },
    },
  }
end

M.status = {
  did_setup = false,
  opened = false,
  reason = nil, ---@type string?
}

--- Check if the dashboard should be opened
function M.setup()
  M.status.did_setup = true
  local buf = 1

  -- don't open the dashboard if there are any arguments
  if vim.fn.argc(-1) > 0 then
    M.status.reason = "argc(-1) > 0"
    return
  end

  -- there should be only one non-floating window and it should be the first buffer
  local wins = vim.tbl_filter(function(win)
    return vim.api.nvim_win_get_config(win).relative == ""
  end, vim.api.nvim_list_wins())
  if #wins ~= 1 then
    M.status.reason = "more than one non-floating window"
    return
  elseif vim.api.nvim_win_get_buf(wins[1]) ~= buf then
    M.status.reason = "window does not contain the first buffer"
    return
  end

  if vim.bo[buf].modified then
    M.status.reason = "buffer is modified"
    return
  end

  local uis = vim.api.nvim_list_uis()

  -- check for headless
  if #uis == 0 then
    M.status.reason = "headless"
    return
  end

  -- don't open the dashboard if in TUI and input is piped
  if uis[1].stdout_tty and not uis[1].stdin_tty then
    M.status.reason = "stdin is not a tty"
    return
  end

  -- don't open the dashboard if there is any text in the buffer
  if vim.api.nvim_buf_line_count(buf) > 1 or #(vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or "") > 0 then
    M.status.reason = "buffer is not empty"
    return
  end
  M.status.opened = true

  if Snacks.config.dashboard.debug then
    Snacks.debug.tracemod("dashboard", M)
    Snacks.debug.tracemod("dashboard", D, ":")
  end

  local options = { showtabline = vim.o.showtabline, laststatus = vim.o.laststatus }
  vim.o.showtabline, vim.o.laststatus = 0, 0
  M.open({ buf = buf, win = wins[1] }).on("Closed", function()
    for k, v in pairs(options) do
      if vim.o[k] == 0 and v ~= 0 then
        vim.o[k] = v
      end
    end
  end)

  if Snacks.config.dashboard.debug then
    Snacks.debug.stats({ min = 0.2 })
  end
end

-- Update the dashboard
function M.update()
  D.fire("Update")
end

function M.health()
  if Snacks.config.dashboard.enabled then
    if M.status.did_setup then
      Snacks.health.ok("setup ran")
      if M.status.opened then
        Snacks.health.ok("dashboard opened")
      else
        Snacks.health.warn("dashboard did not open: `" .. M.status.reason .. "`")
      end
    else
      Snacks.health.error("setup did not run")
    end
    local modnames = { "alpha", "dashboard", "mini.starter" }
    for _, modname in ipairs(modnames) do
      if package.loaded[modname] then
        Snacks.health.error("`" .. modname .. "` conflicts with `Snacks.dashboard`")
      end
    end
  end
end

M.Dashboard = D

return M
