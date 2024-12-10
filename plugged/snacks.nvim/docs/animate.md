# 🍿 animate

Efficient animation library including over 45 easing functions:

- [Emmanuel Oga's easing functions](https://github.com/EmmanuelOga/easing)
- [Easing functions overview](https://github.com/kikito/tween.lua?tab=readme-ov-file#easing-functions)

There's at any given time at most one timer running, that takes
care of all active animations, controlled by the `fps` setting.

<!-- docgen -->

## 📦 Setup

```lua
-- lazy.nvim
{
  "folke/snacks.nvim",
  opts = {
    animate = {
      -- your animate configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  }
}
```

## ⚙️ Config

```lua
---@class snacks.animate.Config
---@field easing? snacks.animate.easing|snacks.animate.easing.Fn
{
  ---@type snacks.animate.Duration|number
  duration = 20, -- ms per step
  easing = "linear",
  fps = 60, -- frames per second. Global setting for all animations
}
```

## 📚 Types

All easing functions take these parameters:

t = time     should go from 0 to duration
b = begin    value of the property being ease.
c = change   ending value of the property - beginning value of the property
d = duration

Some functions allow additional modifiers, like the elastic functions
which also can receive an amplitud and a period parameters (defaults
are included)

```lua
---@alias snacks.animate.easing.Fn fun(t: number, b: number, c: number, d: number): number
```

Duration can be specified as the total duration or the duration per step.
When both are specified, the minimum of both is used.

```lua
---@class snacks.animate.Duration
---@field step? number duration per step in ms
---@field total? number total duration in ms
```

```lua
---@class snacks.animate.Opts: snacks.animate.Config
---@field int? boolean interpolate the value to an integer
---@field id? number|string unique identifier for the animation
```

```lua
---@class snacks.animate.ctx
---@field anim snacks.animate.Animation
---@field prev number
---@field done boolean
```

```lua
---@alias snacks.animate.cb fun(value:number, ctx: snacks.animate.ctx)
```

## 📦 Module

### `Snacks.animate()`

```lua
---@type fun(from: number, to: number, cb: snacks.animate.cb, opts?: snacks.animate.Opts): snacks.animate.Animation
Snacks.animate()
```

### `Snacks.animate.add()`

Add an animation

```lua
---@param from number
---@param to number
---@param cb snacks.animate.cb
---@param opts? snacks.animate.Opts
Snacks.animate.add(from, to, cb, opts)
```

### `Snacks.animate.del()`

Delete an animation

```lua
---@param id number|string
Snacks.animate.del(id)
```
