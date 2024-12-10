# 🍿 input

<!-- docgen -->

## 📦 Setup

```lua
-- lazy.nvim
{
  "folke/snacks.nvim",
  opts = {
    input = {
      -- your input configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  }
}
```

## ⚙️ Config

```lua
---@class snacks.input.Config
---@field enabled? boolean
---@field win? snacks.win.Config
---@field icon? string
{
  icon = " ",
  icon_hl = "SnacksInputIcon",
  win = { style = "input" },
  expand = true,
}
```

## 🎨 Styles

### `input`

```lua
{
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
}
```

## 📚 Types

```lua
---@class snacks.input.Opts: snacks.input.Config
---@field prompt? string
---@field default? string
---@field completion? string
---@field highlight? fun()
```

## 📦 Module

### `Snacks.input()`

```lua
---@type fun(opts: snacks.input.Opts, on_confirm: fun(value?: string)): snacks.win
Snacks.input()
```

### `Snacks.input.disable()`

```lua
Snacks.input.disable()
```

### `Snacks.input.enable()`

```lua
Snacks.input.enable()
```

### `Snacks.input.input()`

```lua
---@param opts? snacks.input.Opts
---@param on_confirm fun(value?: string)
Snacks.input.input(opts, on_confirm)
```
