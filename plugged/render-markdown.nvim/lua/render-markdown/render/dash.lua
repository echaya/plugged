local Base = require('render-markdown.render.base')

---@class render.md.render.Dash: render.md.Renderer
---@field private dash render.md.Dash
local Render = setmetatable({}, Base)
Render.__index = Render

---@return boolean
function Render:setup()
    self.dash = self.config.dash
    if not self.dash.enabled then
        return false
    end
    return true
end

function Render:render()
    local width = self.dash.width
    width = type(width) == 'number' and width or self.context:get_width()
    local virt_text = { self.dash.icon:rep(width), self.dash.highlight }

    local start_row, end_row = self.info.start_row, self.info.end_row - 1
    self.marks:add('dash', start_row, 0, {
        virt_text = { virt_text },
        virt_text_pos = 'overlay',
    })
    if end_row > start_row then
        self.marks:add('dash', end_row, 0, {
            virt_text = { virt_text },
            virt_text_pos = 'overlay',
        })
    end
end

return Render
