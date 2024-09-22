---@class render.md.Extmark
---@field private id? integer
---@field mark render.md.Mark
local Extmark = {}
Extmark.__index = Extmark

---@param mark render.md.Mark
---@return render.md.Extmark
function Extmark.new(mark)
    local self = setmetatable({}, Extmark)
    self.id = nil
    self.mark = mark
    return self
end

---@param hidden Range2?
---@return boolean
function Extmark:overlaps(hidden)
    if hidden == nil then
        return false
    end
    local row = self.mark.start_row
    return row >= hidden[1] and row <= hidden[2]
end

---@param ns_id integer
---@param buf integer
function Extmark:show(ns_id, buf)
    if self.id == nil then
        local mark = self.mark
        mark.opts.strict = false
        self.id = vim.api.nvim_buf_set_extmark(buf, ns_id, mark.start_row, mark.start_col, mark.opts)
    end
end

---@param ns_id integer
---@param buf integer
function Extmark:hide(ns_id, buf)
    if self.id ~= nil then
        vim.api.nvim_buf_del_extmark(buf, ns_id, self.id)
        self.id = nil
    end
end

return Extmark
