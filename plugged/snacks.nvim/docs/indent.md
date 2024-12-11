# 🍿 indent

Visualize indent guides and scopes based on treesitter or indent.

Similar plugins:

- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)
- [mini.indentscope](https://github.com/echasnovski/mini.indentscope)

![image](https://github.com/user-attachments/assets/56a99495-05ab-488e-9619-574cb7ff2b7d)

<!-- docgen -->

## 📦 Setup

```lua
-- lazy.nvim
{
  "folke/snacks.nvim",
  opts = {
    indent = {
      -- your indent configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  }
}
```

## ⚙️ Config

```lua
---@class snacks.indent.Config
---@field enabled? boolean
{
  indent = {
    enabled = true, -- enable indent guides
    char = "│",
    blank = " ",
    -- blank = "∙",
    only_scope = false, -- only show indent guides of the scope
    only_current = false, -- only show indent guides in the current window
    hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides
    -- can be a list of hl groups to cycle through
    -- hl = {
    --     "SnacksIndent1",
    --     "SnacksIndent2",
    --     "SnacksIndent3",
    --     "SnacksIndent4",
    --     "SnacksIndent5",
    --     "SnacksIndent6",
    --     "SnacksIndent7",
    --     "SnacksIndent8",
    -- },
  },
  ---@class snacks.indent.Scope.Config: snacks.scope.Config
  scope = {
    enabled = true, -- enable highlighting the current scope
    -- animate scopes. Enabled by default for Neovim >= 0.10
    -- Works on older versions but has to trigger redraws during animation.
    ---@type snacks.animate.Config|{enabled?: boolean}
    animate = {
      enabled = vim.fn.has("nvim-0.10") == 1,
      easing = "linear",
      duration = {
        step = 20, -- ms per step
        total = 500, -- maximum duration
      },
    },
    char = "│",
    underline = false, -- underline the start of the scope
    only_current = false, -- only show scope in the current window
    hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
  },
  chunk = {
    -- when enabled, scopes will be rendered as chunks, except for the
    -- top-level scope which will be rendered as a scope.
    enabled = false,
    -- only show chunk scopes in the current window
    only_current = false,
    hl = "SnacksIndentChunk", ---@type string|string[] hl group for chunk scopes
    char = {
      corner_top = "┌",
      corner_bottom = "└",
      -- corner_top = "╭",
      -- corner_bottom = "╰",
      horizontal = "─",
      vertical = "│",
      arrow = ">",
    },
  },
  blank = {
    char = " ",
    -- char = "·",
    hl = "SnacksIndentBlank", ---@type string|string[] hl group for blank spaces
  },
  -- filter for buffers to enable indent guides
  filter = function(buf)
    return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
  end,
  priority = 200,
}
```

## 📚 Types

```lua
---@class snacks.indent.Scope: snacks.scope.Scope
---@field win number
---@field step? number
```

## 📦 Module

### `Snacks.indent.animate()`

Toggle scope animations

```lua
Snacks.indent.animate()
```

### `Snacks.indent.disable()`

Disable indent guides

```lua
Snacks.indent.disable()
```

### `Snacks.indent.enable()`

Enable indent guides

```lua
Snacks.indent.enable()
```
