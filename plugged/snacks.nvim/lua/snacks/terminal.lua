---@class snacks.terminal: snacks.win
---@field cmd? string | string[]
---@field opts snacks.terminal.Opts
---@overload fun(cmd?: string|string[], opts?: snacks.terminal.Opts): snacks.terminal
local M = setmetatable({}, {
  __call = function(t, ...)
    return t.toggle(...)
  end,
})

---@class snacks.terminal.Config
---@field win? snacks.win.Config
---@field override? fun(cmd?: string|string[], opts?: snacks.terminal.Opts) Use this to use a different terminal implementation
local defaults = {
  win = { style = "terminal" },
}

---@class snacks.terminal.Opts: snacks.terminal.Config
---@field cwd? string
---@field env? table<string, string>
---@field interactive? boolean

Snacks.config.style("terminal", {
  bo = {
    filetype = "snacks_terminal",
  },
  wo = {},
  keys = {
    gf = function(self)
      local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
      if f == "" then
        Snacks.notify.warn("No file under cursor")
      else
        self:hide()
        vim.schedule(function()
          vim.cmd("e " .. f)
        end)
      end
    end,
    term_normal = {
      "<esc>",
      function(self)
        self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
        if self.esc_timer:is_active() then
          self.esc_timer:stop()
          vim.cmd("stopinsert")
        else
          self.esc_timer:start(200, 0, function() end)
          return "<esc>"
        end
      end,
      mode = "t",
      expr = true,
      desc = "Double escape to normal mode",
    },
  },
})

---@type table<string, snacks.win>
local terminals = {}

--- Open a new terminal window.
---@param cmd? string | string[]
---@param opts? snacks.terminal.Opts
function M.open(cmd, opts)
  local id = vim.v.count1
  opts = Snacks.config.get("terminal", defaults --[[@as snacks.terminal.Opts]], opts)
  opts.win = Snacks.win.resolve("terminal", {
    position = cmd and "float" or "bottom",
  }, opts.win)
  opts.win.wo.winbar = opts.win.wo.winbar or (opts.win.position == "float" and "" or (id .. ": %{b:term_title}"))

  if opts.override then
    return opts.override(cmd, opts)
  end

  local on_buf = opts.win and opts.win.on_buf

  ---@param self snacks.terminal
  opts.win.on_buf = function(self)
    self.cmd = cmd
    vim.b[self.buf].snacks_terminal = { cmd = cmd, id = id }
    if on_buf then
      on_buf(self)
    end
  end

  local terminal = Snacks.win(opts.win)

  vim.api.nvim_buf_call(terminal.buf, function()
    local term_opts = {
      cwd = opts.cwd,
      env = opts.env,
    }
    vim.fn.termopen(cmd or M.parse(vim.o.shell), vim.tbl_isempty(term_opts) and vim.empty_dict() or term_opts)
  end)

  if opts.interactive ~= false then
    vim.cmd.startinsert()
    vim.api.nvim_create_autocmd("TermClose", {
      once = true,
      buffer = terminal.buf,
      callback = function()
        if type(vim.v.event) == "table" and vim.v.event.status ~= 0 then
          Snacks.notify.error("Terminal exited with code " .. vim.v.event.status .. ".\nCheck for any errors.")
          return
        end
        terminal:close()
        vim.cmd.checktime()
      end,
    })
    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = terminal.buf,
      callback = function()
        vim.cmd.startinsert()
      end,
    })
  end
  vim.cmd("noh")
  return terminal
end

--- Toggle a terminal window.
--- The terminal id is based on the `cmd`, `cwd`, `env` and `vim.v.count1` options.
---@param cmd? string | string[]
---@param opts? snacks.terminal.Opts
function M.toggle(cmd, opts)
  opts = opts or {}

  local id = vim.inspect({ cmd = cmd, cwd = opts.cwd, env = opts.env, count = vim.v.count1 })

  if terminals[id] and terminals[id]:buf_valid() then
    terminals[id]:toggle()
  else
    terminals[id] = M.open(cmd, opts)
  end
  return terminals[id]
end

--- Parses a shell command into a table of arguments.
--- - spaces inside quotes (only double quotes are supported) are preserved
--- - backslash
---@private
---@param cmd string
function M.parse(cmd)
  local args = {}
  local in_quotes, escape_next, current = false, false, ""
  local function add()
    if #current > 0 then
      table.insert(args, current)
      current = ""
    end
  end

  for i = 1, #cmd do
    local char = cmd:sub(i, i)
    if escape_next then
      current = current .. ((char == '"' or char == "\\") and "" or "\\") .. char
      escape_next = false
    elseif char == "\\" and in_quotes then
      escape_next = true
    elseif char == '"' then
      in_quotes = not in_quotes
    elseif char:find("[ \t]") and not in_quotes then
      add()
    else
      current = current .. char
    end
  end
  add()
  return args
end

--- Colorize the current buffer.
--- Replaces ansii color codes with the actual colors.
---
--- Example:
---
--- ```sh
--- ls -la --color=always | nvim - -c "lua Snacks.terminal.colorize()"
--- ```
function M.colorize()
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.statuscolumn = ""
  vim.wo.signcolumn = "no"
  vim.opt.listchars = { space = " " }

  local buf = vim.api.nvim_get_current_buf()

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  while #lines > 0 and vim.trim(lines[#lines]) == "" do
    lines[#lines] = nil
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

  vim.api.nvim_chan_send(vim.api.nvim_open_term(buf, {}), table.concat(lines, "\r\n"))
  vim.keymap.set("n", "q", "<cmd>q<cr>", { silent = true, buffer = buf })
  vim.api.nvim_create_autocmd("TextChanged", {
    buffer = buf,
    callback = function()
      pcall(vim.api.nvim_win_set_cursor, 0, { #lines, 0 })
    end,
  })
  vim.api.nvim_create_autocmd("TermEnter", { buffer = buf, command = "stopinsert" })
end

---@private
function M.health()
  local cmd = M.parse(vim.o.shell)
  local ok = cmd[1] and (vim.fn.executable(cmd[1]) == 1)
  local msg = ("shell %s\n- `vim.o.shell`: %s\n- `parsed`: %s"):format(
    ok and "configured" or "not found",
    vim.o.shell,
    vim.inspect(cmd)
  )
  Snacks.health[ok and "ok" or "error"](msg)
end

return M
