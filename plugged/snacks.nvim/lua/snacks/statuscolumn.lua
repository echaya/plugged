local Snacks = require("snacks")

---@class snacks.statuscolumn
---@overload fun(): string
local M = setmetatable({}, {
  __call = function(t)
    return t.get()
  end,
})

---@class snacks.statuscolumn.Config
---@field enabled? boolean
local defaults = {
  left = { "mark", "sign" }, -- priority of signs on the left (high to low)
  right = { "fold", "git" }, -- priority of signs on the right (high to low)
  folds = {
    open = false, -- show open fold icons
    git_hl = false, -- use Git Signs hl for fold icons
  },
  git = {
    -- patterns to match Git signs
    patterns = { "GitSign", "MiniDiffSign" },
  },
  refresh = 50, -- refresh at most every 50ms
}

local config = Snacks.config.get("statuscolumn", defaults)

---@private
---@alias snacks.statuscolumn.Sign.type "mark"|"sign"|"fold"|"git"
---@alias snacks.statuscolumn.Sign {name:string, text:string, texthl:string, priority:number, type:snacks.statuscolumn.Sign.type}

-- Cache for signs per buffer and line
---@type table<number,table<number,snacks.statuscolumn.Sign[]>>
local cache = {}

local did_setup = false

---@private
function M.setup()
  if did_setup then
    return
  end
  did_setup = true
  local timer = assert((vim.uv or vim.loop).new_timer())
  timer:start(config.refresh, config.refresh, function()
    cache = {}
  end)
end

---@private
---@param name string
function M.is_git_sign(name)
  for _, pattern in ipairs(config.git.patterns) do
    if name:find(pattern) then
      return true
    end
  end
end

-- Returns a list of regular and extmark signs sorted by priority (low to high)
---@private
---@return table<number, snacks.statuscolumn.Sign[]>
---@param buf number
function M.buf_signs(buf)
  if cache[buf] then
    return cache[buf]
  end

  -- Get regular signs
  ---@type table<number, snacks.statuscolumn.Sign[]>
  local signs = {}

  if vim.fn.has("nvim-0.10") == 0 then
    -- Only needed for Neovim <0.10
    -- Newer versions include legacy signs in nvim_buf_get_extmarks
    for _, sign in ipairs(vim.fn.sign_getplaced(buf, { group = "*" })[1].signs) do
      local ret = vim.fn.sign_getdefined(sign.name)[1] --[[@as snacks.statuscolumn.Sign]]
      if ret then
        ret.priority = sign.priority
        ret.type = M.is_git_sign(sign.name) and "git" or "sign"
        signs[sign.lnum] = signs[sign.lnum] or {}
        table.insert(signs[sign.lnum], ret)
      end
    end
  end

  -- Get extmark signs
  local extmarks = vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, { details = true, type = "sign" })
  for _, extmark in pairs(extmarks) do
    local lnum = extmark[2] + 1
    signs[lnum] = signs[lnum] or {}
    local name = extmark[4].sign_hl_group or extmark[4].sign_name or ""
    table.insert(signs[lnum], {
      name = name,
      type = M.is_git_sign(name) and "git" or "sign",
      text = extmark[4].sign_text,
      texthl = extmark[4].sign_hl_group,
      priority = extmark[4].priority,
    })
  end

  -- Add marks
  local marks = vim.fn.getmarklist(buf)
  vim.list_extend(marks, vim.fn.getmarklist())
  for _, mark in ipairs(marks) do
    if mark.pos[1] == buf and mark.mark:match("[a-zA-Z]") then
      local lnum = mark.pos[2]
      signs[lnum] = signs[lnum] or {}
      table.insert(signs[lnum], { text = mark.mark:sub(2), texthl = "DiagnosticHint", type = "mark" })
    end
  end

  cache[buf] = signs
  return signs
end

-- Returns a list of regular and extmark signs sorted by priority (high to low)
---@private
---@param win number
---@param buf number
---@param lnum number
---@return snacks.statuscolumn.Sign[]
function M.line_signs(win, buf, lnum)
  local signs = M.buf_signs(buf)[lnum] or {}

  -- Get fold signs
  vim.api.nvim_win_call(win, function()
    if vim.fn.foldclosed(vim.v.lnum) >= 0 then
      signs[#signs + 1] = { text = vim.opt.fillchars:get().foldclose or "", texthl = "Folded", type = "fold" }
    elseif config.folds.open and tostring(vim.treesitter.foldexpr(vim.v.lnum)):sub(1, 1) == ">" then
      signs[#signs + 1] = { text = vim.opt.fillchars:get().foldopen or "", type = "fold" }
    end
  end)

  -- Sort by priority
  table.sort(signs, function(a, b)
    return (a.priority or 0) > (b.priority or 0)
  end)
  return signs
end

---@private
---@param sign? snacks.statuscolumn.Sign
---@param len? number
function M.icon(sign, len)
  sign = sign or {}
  len = len or 2
  local text = vim.fn.strcharpart(sign.text or "", 0, len) ---@type string
  text = text .. string.rep(" ", len - vim.fn.strchars(text))
  return sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
end

---@return string
function M.get()
  M.setup()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local is_file = vim.bo[buf].buftype == ""
  local show_signs = vim.wo[win].signcolumn ~= "no"

  local components = { "", "", "" } -- left, middle, right

  if show_signs then
    local signs = M.line_signs(win, buf, vim.v.lnum)

    ---@param types snacks.statuscolumn.Sign.type[]
    local function find(types)
      for _, t in ipairs(types) do
        for _, s in ipairs(signs) do
          if s.type == t then
            return s
          end
        end
      end
    end

    local left = find(config.left)
    local right = find(config.right)

    if config.folds.git_hl then
      local git = find({ "git" })
      if git and left and left.type == "fold" then
        left.texthl = git.texthl
      end
      if git and right and right.type == "fold" then
        right.texthl = git.texthl
      end
    end

    components[1] = M.icon(left) -- left
    components[3] = is_file and M.icon(right) or "" -- right
  end

  -- Numbers in Neovim are weird
  -- They show when either number or relativenumber is true
  local is_num = vim.wo[win].number
  local is_relnum = vim.wo[win].relativenumber
  if (is_num or is_relnum) and vim.v.virtnum == 0 then
    if vim.fn.has("nvim-0.11") == 1 then
      components[2] = "%l" -- 0.11 handles both the current and other lines with %l
    else
      if vim.v.relnum == 0 then
        components[2] = is_num and "%l" or "%r" -- the current line
      else
        components[2] = is_relnum and "%r" or "%l" -- other lines
      end
    end
    components[2] = "%=" .. components[2] .. " " -- right align
  end

  if vim.v.virtnum ~= 0 then
    components[2] = "%= "
  end

  return table.concat(components, "")
end

local get = M.get
function M.get()
  local ok, ret = pcall(get)
  return not ok and "" or ret
end

---@private
function M.health()
  local ready = vim.o.statuscolumn:find("snacks.statuscolumn", 1, true)
  if config.enabled and not ready then
    Snacks.health.warn(("is not configured\n- `vim.o.statuscolumn = %q`"):format(vim.o.statuscolumn))
  elseif not config.enabled and ready then
    Snacks.health.ok(("is manually configured\n- `vim.o.statuscolumn = %q`"):format(vim.o.statuscolumn))
  end
end

return M
