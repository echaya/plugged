# 🍿 profiler

## ✨ Features

- low overhead **instrumentation**
- captures a function's **def**inition and **ref**erence (_caller_) locations
- profiling of **autocmds**
- profiling of **require**d modules
- buffer **highlighting** of functions and calls
- lots of different ways to **filter** and **group** traces
- show traces with:
  - [fzf-lua](https://github.com/ibhagwan/fzf-lua)
  - [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
  - [trouble.nvim](https://github.com/folke/trouble.nvim)

## ⁉️ Why?

Before the snacks profiler, I used to use a combination of my own profiler(s),
**lazy.nvim**'s internal profiler, [profile.nvim](https://github.com/stevearc/profile.nvim)
and [perfanno.nvim](https://github.com/t-troebst/perfanno.nvim).

They all have their strengths and weaknesses:

- **lazy.nvim**'s profiler is great for structured traces, but needed a lot of
  manual work to get the traces I wanted.
- **profile.nvim** does proper instrumentation, but was lacking in the UI department.
- **perfanno.nvim** has a great UI, but uses `jit.profile` which is not as
  detailed as instrumentation.

The snacks profiler tries to combine the best of all worlds.

## 🚀 Usage

The easiest way to use the profiler is to toggle it with the suggested keybindings.

When the profiler stops, it will show a picker using the `on_stop` preset.

To quickly change picker options, you can use the `Snacks.profiler.scratch()`
scratch buffer.

### Caveats

- your Neovim session might slow down when profiling
- due to the overhead of instrumentation, fast functions that are called
  often, might skew the results. Best to add those to the `opts.filter_fn` config.
- by default, only captures functions defined on lua modules.
  If you want to profile others, add them to `opts.globals`
- the profiler is not perfect and might not capture all calls
- the profiler might not work well with some plugins
- it can only profile `autocmds` created when the profiler is running.
- only `autocms` with a lua function callback can be profiled
- functions that `resume` or `yield` won't be captured correctly
- functions that do blocking calls like `vim.fn.getchar` will work,
  but the time will include the time spent waiting for the blocking call

### Recommended Setup

```lua
{
  {
    "folke/snacks.nvim",
    opts = function()
      -- Toggle the profiler
      Snacks.toggle.profiler():map("<leader>pp")
      -- Toggle the profiler highlights
      Snacks.toggle.profiler_highlights():map("<leader>ph")
    end,
    keys = {
      { "<leader>ps", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Bufer" },
    }
  },
  -- optional lualine component to show captured events
  -- when the profiler is running
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, Snacks.profiler.status())
    end,
  },
}
```

### Profiling Neovim Startup

In order to profile Neovim's startup, you need to make sure `snacks.nvim` is
installed and loaded **before** doing anything else. So also before loading
your plugin manager.

You can add something like the below to the top of your `init.lua`.

Then you can profile your Neovim session, with `PROF=1 nvim`.

```lua
if vim.env.PROF then
  -- example for lazy.nvim
  -- change this to the correct path for your plugin manager
  local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
  vim.opt.rtp:append(snacks)
  require("snacks.profiler").startup({
    startup = {
      event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
      -- event = "UIEnter",
      -- event = "VeryLazy",
    },
  })
end
```

### Filtering

For the full definition, see the `snacks.profiler.Filter` type.

Each field can be a string or a boolean.

When a field is a string, it will match the exact value,
unless it starts with `^` in which case it will match the pattern.

When any of the `def`/`ref` fields are `true`,
the filter matches the current location of the cursor.

For example, `{ref_file = true}` will match all traces calling something,
in the current file.

All other fields equal to `true` will match if the trace has a value for that field.

<!-- docgen -->

## ⚙️ Config

```lua
---@class snacks.profiler.Config
{
  autocmds = true,
  runtime = vim.env.VIMRUNTIME, ---@type string
  -- thresholds for buttons to be shown as info, warn or error
  -- value is a tuple of [warn, error]
  thresholds = {
    time = { 2, 10 },
    pct = { 10, 20 },
    count = { 10, 100 },
  },
  on_stop = {
    highlights = true, -- highlight entries after stopping the profiler
    pick = true, -- show a picker after stopping the profiler (uses the `on_stop` preset)
  },
  ---@type snacks.profiler.Highlights
  highlights = {
    min_time = 0, -- only highlight entries with time > min_time (in ms)
    max_shade = 20, -- time in ms for the darkest shade
    badges = { "time", "pct", "count", "trace" },
    align = 80,
  },
  pick = {
    picker = "auto", ---@type snacks.profiler.Picker
    ---@type snacks.profiler.Badge.type[]
    badges = { "time", "count", "name" },
    ---@type snacks.profiler.Highlights
    preview = {
      badges = { "time", "pct", "count" },
      align = "right",
    },
  },
  startup = {
    event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
    after = true, -- stop the profiler **after** the event. When false it stops **at** the event
    pattern = nil, -- pattern to match for the autocmd
    pick = true, -- show a picker after starting the profiler (uses the `startup` preset)
  },
  ---@type table<string, snacks.profiler.Pick|fun():snacks.profiler.Pick>
  presets = {
    startup = { min_time = 1, sort = false },
    on_stop = {},
    filter_by_plugin = function()
      return { filter = { def_plugin = vim.fn.input("Filter by plugin: ") } }
    end,
  },
  ---@type string[]
  globals = {
    -- "vim",
    -- "vim.api",
    -- "vim.keymap",
    -- "Snacks.dashboard.Dashboard",
  },
  -- filter modules by pattern.
  -- longest patterns are matched first
  filter_mod = {
    default = true, -- default value for unmatched patterns
    ["^vim%."] = false,
    ["mason-core.functional"] = false,
    ["mason-core.functional.data"] = false,
    ["mason-core.optional"] = false,
    ["which-key.state"] = false,
  },
  filter_fn = {
    default = true,
    ["^.*%._[^%.]*$"] = false,
    ["trouble.filter.is"] = false,
    ["trouble.item.__index"] = false,
    ["which-key.node.__index"] = false,
    ["smear_cursor.draw.wo"] = false,
    ["^ibl%.utils%."] = false,
  },
  icons = {
    time    = " ",
    pct     = " ",
    count   = " ",
    require = "󰋺 ",
    modname = "󰆼 ",
    plugin  = " ",
    autocmd = "⚡",
    file    = " ",
    fn      = "󰊕 ",
    status  = "󰈸 ",
  },
}
```

## 📚 Types

### Traces

```lua
---@class snacks.profiler.Trace
---@field name string fully qualified name of the function
---@field time number time in nanoseconds
---@field depth number stack depth
---@field [number] snacks.profiler.Trace child traces
---@field fname string function name
---@field fn function function reference
---@field modname? string module name
---@field require? string special case for require
---@field autocmd? string special case for autocmd
---@field count? number number of calls
---@field def? snacks.profiler.Loc location of the definition
---@field ref? snacks.profiler.Loc location of the reference (caller)
---@field loc? snacks.profiler.Loc normalized location
```

```lua
---@class snacks.profiler.Loc
---@field file string path to the file
---@field line number line number
---@field loc? string normalized location
---@field modname? string module name
---@field plugin? string plugin name
```

### Pick: grouping, filtering and sorting

```lua
---@class snacks.profiler.Find
---@field structure? boolean show traces as a tree or flat list
---@field sort? "time"|"count"|false sort by time or count, or keep original order
---@field loc? "def"|"ref" what location to show in the preview
---@field group? boolean|snacks.profiler.Field group traces by field
---@field filter? snacks.profiler.Filter filter traces by field(s)
---@field min_time? number only show grouped traces with `time >= min_time`
```

```lua
---@class snacks.profiler.Pick: snacks.profiler.Find
---@field picker? snacks.profiler.Picker
```

```lua
---@alias snacks.profiler.Picker "auto"|"fzf-lua"|"telescope"|"trouble"
---@alias snacks.profiler.Pick.spec snacks.profiler.Pick|{preset?:string}|fun():snacks.profiler.Pick
```

```lua
---@alias snacks.profiler.Field
---| "name" fully qualified name of the function
---| "def" definition
---| "ref" reference (caller)
---| "require" require
---| "autocmd" autocmd
---| "modname" module name of the called function
---| "def_file" file of the definition
---| "def_modname" module name of the definition
---| "def_plugin" plugin that defines the function
---| "ref_file" file of the reference
---| "ref_modname" module name of the reference
---| "ref_plugin" plugin that references the function
```

```lua
---@class snacks.profiler.Filter
---@field name? string|boolean fully qualified name of the function
---@field def? string|boolean location of the definition
---@field ref? string|boolean location of the reference (caller)
---@field require? string|boolean special case for require
---@field autocmd? string|boolean special case for autocmd
---@field modname? string|boolean module name
---@field def_file? string|boolean file of the definition
---@field def_modname? string|boolean module name of the definition
---@field def_plugin? string|boolean plugin that defines the function
---@field ref_file? string|boolean file of the reference
---@field ref_modname? string|boolean module name of the reference
---@field ref_plugin? string|boolean plugin that references the function
```

### UI

```lua
---@alias snacks.profiler.Badge {icon:string, text:string, padding?:boolean, level?:string}
---@alias snacks.profiler.Badge.type "time"|"pct"|"count"|"name"|"trace"
```

```lua
---@class snacks.profiler.Highlights
---@field min_time? number only highlight entries with time >= min_time
---@field max_shade? number -- time in ms for the darkest shade
---@field badges? snacks.profiler.Badge.type[] badges to show
---@field align? "right"|"left"|number align the badges right, left or at a specific column
```

### Other

```lua
---@class snacks.profiler.Startup
---@field event? string
---@field pattern? string|string[] pattern to match for the autocmd
```

```lua
---@alias snacks.profiler.GroupFn fun(entry:snacks.profiler.Trace):{key:string, name?:string}?
```

## 📦 Module

```lua
---@class snacks.profiler
---@field core snacks.profiler.core
---@field loc snacks.profiler.loc
---@field tracer snacks.profiler.tracer
---@field ui snacks.profiler.ui
---@field picker snacks.profiler.picker
Snacks.profiler = {}
```

### `Snacks.profiler.find()`

Group and filter traces

```lua
---@param opts snacks.profiler.Find
Snacks.profiler.find(opts)
```

### `Snacks.profiler.highlight()`

Toggle the profiler highlights

```lua
---@param enable? boolean
Snacks.profiler.highlight(enable)
```

### `Snacks.profiler.pick()`

Group and filter traces and open a picker

```lua
---@param opts? snacks.profiler.Pick.spec
Snacks.profiler.pick(opts)
```

### `Snacks.profiler.running()`

Check if the profiler is running

```lua
Snacks.profiler.running()
```

### `Snacks.profiler.scratch()`

Open a scratch buffer with the profiler picker options

```lua
Snacks.profiler.scratch()
```

### `Snacks.profiler.start()`

Start the profiler

```lua
---@param opts? snacks.profiler.Config
Snacks.profiler.start(opts)
```

### `Snacks.profiler.startup()`

Start the profiler on startup, and stop it after the event has been triggered.

```lua
---@param opts snacks.profiler.Config
Snacks.profiler.startup(opts)
```

### `Snacks.profiler.status()`

Statusline component

```lua
Snacks.profiler.status()
```

### `Snacks.profiler.stop()`

Stop the profiler

```lua
---@param opts? {highlights?:boolean, pick?:snacks.profiler.Pick.spec}
Snacks.profiler.stop(opts)
```

### `Snacks.profiler.toggle()`

Toggle the profiler

```lua
Snacks.profiler.toggle()
```
