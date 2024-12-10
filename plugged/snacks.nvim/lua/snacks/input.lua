---@class snacks.input
---@overload fun(opts: snacks.input.Opts, on_confirm: fun(value?: string)): snacks.win
local M = setmetatable({}, {
  __call = function(M, ...)
    return M.input(...)
  end,
})

M.meta = {
  desc = "Better `vim.ui.input`",
  needs_setup = true,
}

---@class snacks.input.Config
---@field enabled? boolean
---@field win? snacks.win.Config
---@field icon? string
local defaults = {
  icon = " ",
  icon_hl = "SnacksInputIcon",
  win = { style = "input" },
  expand = true,
}

Snacks.util.set_hl({
  Icon = "DiagnosticHint",
  Normal = "Normal",
  Border = "DiagnosticInfo",
  Title = "DiagnosticInfo",
}, { prefix = "SnacksInput", default = true })

Snacks.config.style("input", {
  backdrop = false,
  position = "float",
  border = "rounded",
  title_pos = "center",
  height = 1,
  width = 60,
  relative = "editor",
  row = 2,
  -- relative = "cursor",
  -- row = -3,
  -- col = 0,
  wo = {
    winhighlight = "NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
  },
  keys = {
    i_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "i" },
    -- i_esc = { "<esc>", "stopinsert", mode = "i" },
    i_cr = { "<cr>", { "cmp_accept", "confirm" }, mode = "i" },
    i_tab = { "<tab>", { "cmp_select_next", "cmp" }, mode = "i" },
    q = "cancel",
  },
})

local ui_input = vim.ui.input

---@class snacks.input.Opts: snacks.input.Config
---@field prompt? string
---@field default? string
---@field completion? string
---@field highlight? fun()

---@class snacks.input.ctx
---@field opts? snacks.input.Opts
---@field win? snacks.win
local ctx = {}

---@param opts? snacks.input.Opts
---@param on_confirm fun(value?: string)
function M.input(opts, on_confirm)
  assert(type(on_confirm) == "function", "`on_confirm` must be a function")
  local function confirm(value)
    ctx.win = nil
    ctx.opts = nil
    vim.cmd.stopinsert()
    vim.schedule_wrap(on_confirm)(value)
  end

  opts = Snacks.config.get("input", defaults, opts) --[[@as snacks.input.Opts]]

  opts.win = Snacks.win.resolve("input", opts.win, {
    enter = true,
    title = (" %s "):format(vim.trim(opts.prompt or "Input")),
    bo = {
      modifiable = true,
      completefunc = "v:lua.Snacks.input.complete",
      omnifunc = "v:lua.Snacks.input.complete",
    },
    wo = { statuscolumn = " %#" .. opts.icon_hl .. "#" .. opts.icon .. " " },
    actions = {
      cancel = function(self)
        confirm()
        self:close()
      end,
      stopinsert = function()
        vim.cmd("stopinsert")
      end,
      confirm = function(self)
        confirm(self:text())
        self:close()
      end,
      cmp = function()
        return vim.fn.pumvisible() == 0 and "<c-x><c-u>"
      end,
      cmp_close = function()
        return vim.fn.pumvisible() == 1 and "<c-e>"
      end,
      cmp_accept = function()
        return vim.fn.pumvisible() == 1 and "<c-y>"
      end,
      cmp_select_next = function()
        return vim.fn.pumvisible() == 1 and "<c-n>"
      end,
      cmp_select_prev = function()
        return vim.fn.pumvisible() == 1 and "<c-p>"
      end,
    },
  })

  local min_width = opts.win.width or 60
  if opts.expand then
    ---@param self snacks.win
    opts.win.width = function(self)
      local w = type(min_width) == "function" and min_width(self) or min_width --[[@as number]]
      return math.max(w, vim.api.nvim_strwidth(self:text()) + 5)
    end
  end

  local win = Snacks.win(opts.win)
  ctx = { opts = opts, win = win }
  vim.cmd.startinsert()
  if opts.default then
    vim.api.nvim_buf_set_lines(win.buf, 0, -1, false, { opts.default })
    vim.api.nvim_win_set_cursor(win.win, { 1, #opts.default + 1 })
  end

  if opts.expand then
    vim.api.nvim_create_autocmd("TextChangedI", {
      buffer = win.buf,
      callback = function()
        win:update()
        vim.api.nvim_win_call(win.win, function()
          vim.fn.winrestview({ leftcol = 0 })
        end)
      end,
    })
  end

  return win
end

---@param findstart number
---@param base string
---@private
function M.complete(findstart, base)
  local completion = ctx.opts.completion
  if findstart == 1 then
    return 0
  end
  if not completion then
    return {}
  end
  local ok, results = pcall(vim.fn.getcompletion, base, completion)
  return ok and results or {}
end

function M.enable()
  vim.ui.input = M.input
end

function M.disable()
  vim.ui.input = ui_input
end

---@private
function M.health()
  if Snacks.config.get("input", defaults).enabled then
    if vim.ui.input == M.input then
      Snacks.health.ok("`vim.ui.input` is set to `Snacks.input`")
    else
      Snacks.health.error("`vim.ui.input` is not set to `Snacks.input`")
    end
  end
end

return M
