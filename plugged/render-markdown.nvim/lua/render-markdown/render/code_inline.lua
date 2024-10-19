local Base = require('render-markdown.render.base')

---@class render.md.render.CodeInline: render.md.Renderer
---@field private code render.md.Code
local Render = setmetatable({}, Base)
Render.__index = Render

---@return boolean
function Render:setup()
    self.code = self.config.code
    if not self.code.enabled or not vim.tbl_contains({ 'normal', 'full' }, self.code.style) then
        return false
    end
    return true
end

function Render:render()
    self.marks:add('code_background', self.info.start_row, self.info.start_col, {
        end_row = self.info.end_row,
        end_col = self.info.end_col,
        hl_group = self.code.highlight_inline,
    })
end

return Render
