---@class snacks.git
local M = {}

Snacks.config.style("blame_line", {
  width = 0.6,
  height = 0.6,
  border = "rounded",
  title = " Git Blame ",
  title_pos = "center",
  ft = "git",
})

--- Gets the git root for a buffer or path.
--- Defaults to the current buffer.
---@param path? number|string buffer or path
function M.get_root(path)
  path = path or 0
  path = type(path) == "number" and vim.api.nvim_buf_get_name(path) or path --[[@as string]]
  path = vim.fs.normalize(path)
  local git_root ---@type string?
  for dir in vim.fs.parents(path) do
    if vim.fn.isdirectory(dir .. "/.git") == 1 then
      git_root = dir
      break
    end
  end
  return git_root and vim.fs.normalize(git_root) or nil
end

--- Show git log for the current line.
---@param opts? snacks.terminal.Opts | {count?: number}
function M.blame_line(opts)
  opts = vim.tbl_deep_extend("force", {
    count = 5,
    interactive = false,
    win = { style = "blame_line" },
  }, opts or {})
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1]
  local file = vim.api.nvim_buf_get_name(0)
  local root = M.get_root()
  local cmd = { "git", "-C", root, "log", "-n", opts.count, "-u", "-L", line .. ",+1:" .. file }
  return Snacks.terminal(cmd, opts)
end

return M
