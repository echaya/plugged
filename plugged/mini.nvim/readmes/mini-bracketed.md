<img src="https://github.com/echasnovski/media/blob/main/mini.nvim/logo/logo_bracketed.png" style="width: 100%">

<!-- badges: start -->
[![GitHub license](https://badgen.net/github/license/echasnovski/mini.nvim)](https://github.com/echasnovski/mini.nvim/blob/main/LICENSE)
<!-- badges: end -->

### Go forward/backward with square brackets

See more details in [Features](#features) and [help file](../doc/mini-bracketed.txt).

---

⦿ This is a part of [mini.nvim](https://github.com/echasnovski/mini.nvim) library. Please use [this link](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-bracketed.md) if you want to mention this module.

⦿ All contributions (issues, pull requests, discussions, etc.) are done inside of 'mini.nvim'.

⦿ See the repository page to learn about common design principles and configuration recipes.

---

If you want to help this project grow but don't know where to start, check out [contributing guides of 'mini.nvim'](https://github.com/echasnovski/mini.nvim/blob/main/CONTRIBUTING.md) or leave a Github star for 'mini.nvim' project and/or any its standalone Git repositories.

## Demo

https://user-images.githubusercontent.com/24854248/220173251-cd905d8f-ad07-4654-bba5-971220fad80a.mp4

## Features

- Configurable Lua functions to go forward/backward to a certain target. Each function can be customized with:
    - Direction. One of "forward", "backward", "first" (forward starting from first one), "last" (backward starting from last one).
    - Number of times to go.
    - Whether to wrap on edges (going forward on last one goes to first).
    - Some other target specific options.

- Mappings using square brackets. They are created using configurable target suffix and can be selectively disabled.

  Each mapping supports |[count]|. Mappings are created in Normal mode; for targets which move cursor in current buffer also Visual and Operator-pending (with dot-repeat) modes are supported.

  Using `lower-suffix` and `upper-suffix` (lower and upper case suffix) for a single target the following mappings are created:
    - `[` + `upper-suffix` : go first.
    - `[` + `lower-suffix` : go backward.
    - `]` + `lower-suffix` : go forward.
    - `]` + `upper-suffix` : go last.

- Supported targets (for more information see help for corresponding Lua function):

    | Target                                            | Mappings            | Lua function                 |
    |---------------------------------------------------|---------------------|------------------------------|
    | Buffer                                            | `[B` `[b` `]b` `]B` | `MiniBracketed.buffer()`     |
    | Comment block                                     | `[C` `[c` `]c` `]C` | `MiniBracketed.comment()`    |
    | Conflict marker                                   | `[X` `[x` `]x` `]X` | `MiniBracketed.conflict()`   |
    | Diagnostic                                        | `[D` `[d` `]d` `]D` | `MiniBracketed.diagnostic()` |
    | File on disk                                      | `[F` `[f` `]f` `]F` | `MiniBracketed.file()`       |
    | Indent change                                     | `[I` `[i` `]i` `]I` | `MiniBracketed.indent()`     |
    | Jump from jumplist inside current buffer          | `[J` `[j` `]j` `]J` | `MiniBracketed.jump()`       |
    | Location from location list                       | `[L` `[l` `]l` `]L` | `MiniBracketed.location()`   |
    | Old files                                         | `[O` `[o` `]o` `]O` | `MiniBracketed.oldfile()`    |
    | Quickfix entry from quickfix list                 | `[Q` `[q` `]q` `]Q` | `MiniBracketed.quickfix()`   |
    | Tree-sitter node and parents                      | `[T` `[t` `]t` `]T` | `MiniBracketed.treesitter()` |
    | Undo states from specially tracked linear history | `[U` `[u` `]u` `]U` | `MiniBracketed.undo()`       |
    | Window in current tab                             | `[W` `[w` `]w` `]W` | `MiniBracketed.window()`     |
    | Yank selection replacing latest put region        | `[Y` `[y` `]y` `]Y` | `MiniBracketed.yank()`       |

Notes:
- The `undo` target remaps `u` and `<C-R>` keys to register undo state after undo and redo respectively. If this conflicts with your setup, either disable `undo` target or make your remaps after calling `MiniBracketed.setup()`. To use `undo` target, remap your undo/redo keys to call `MiniBracketed.register_undo_state()` after the action.

## Installation

This plugin can be installed as part of 'mini.nvim' library (**recommended**) or as a standalone Git repository.

There are two branches to install from:

- `main` (default, **recommended**) will have latest development version of plugin. All changes since last stable release should be perceived as being in beta testing phase (meaning they already passed alpha-testing and are moderately settled).
- `stable` will be updated only upon releases with code tested during public beta-testing phase in `main` branch.

Here are code snippets for some common installation methods (use only one):

<details>
<summary>With <a href="https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-deps.md">mini.deps</a></summary>
<table>
    <thead>
        <tr>
            <th>Github repo</th>
            <th>Branch</th> <th>Code snippet</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=2>'mini.nvim' library</td> <td>Main</td> <td rowspan=2><i>Follow recommended 'mini.deps' installation</i></td>
        </tr>
        <tr>
            <td>Stable</td>
        </tr>
        <tr>
            <td rowspan=2>Standalone plugin</td> <td>Main</td> <td><code>add('echasnovski/mini.bracketed')</code></td>
        </tr>
        <tr>
            <td>Stable</td> <td><code>add({ source = 'echasnovski/mini.bracketed', checkout = 'stable' })</code></td>
        </tr>
    </tbody>
</table>
</details>

<details>
<summary>With <a href="https://github.com/folke/lazy.nvim">folke/lazy.nvim</a></summary>
<table>
    <thead>
        <tr>
            <th>Github repo</th>
            <th>Branch</th> <th>Code snippet</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=2>'mini.nvim' library</td>
            <td>Main</td> <td><code>{ 'echasnovski/mini.nvim', version = false },</code></td>
        </tr>
        <tr>
            <td>Stable</td> <td><code>{ 'echasnovski/mini.nvim', version = '*' },</code></td>
        </tr>
        <tr>
            <td rowspan=2>Standalone plugin</td>
            <td>Main</td> <td><code>{ 'echasnovski/mini.bracketed', version = false },</code></td>
        </tr>
        <tr>
            <td>Stable</td> <td><code>{ 'echasnovski/mini.bracketed', version = '*' },</code></td>
        </tr>
    </tbody>
</table>
</details>

<details>
<summary>With <a href="https://github.com/junegunn/vim-plug">junegunn/vim-plug</a></summary>
<table>
    <thead>
        <tr>
            <th>Github repo</th>
            <th>Branch</th> <th>Code snippet</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=2>'mini.nvim' library</td>
            <td>Main</td> <td><code>Plug 'echasnovski/mini.nvim'</code></td>
        </tr>
        <tr>
            <td>Stable</td> <td><code>Plug 'echasnovski/mini.nvim', { 'branch': 'stable' }</code></td>
        </tr>
        <tr>
            <td rowspan=2>Standalone plugin</td> <td>Main</td> <td><code>Plug 'echasnovski/mini.bracketed'</code></td>
        </tr>
        <tr>
            <td>Stable</td> <td><code>Plug 'echasnovski/mini.bracketed', { 'branch': 'stable' }</code></td>
        </tr>
    </tbody>
</table>
</details>

<br>

**Important**: don't forget to call `require('mini.bracketed').setup()` to enable its functionality.

**Note**: if you are on Windows, there might be problems with too long file paths (like `error: unable to create file <some file name>: Filename too long`). Try doing one of the following:
- Enable corresponding git global config value: `git config --system core.longpaths true`. Then try to reinstall.
- Install plugin in other place with shorter path.

## Default config

```lua
-- No need to copy this inside `setup()`. Will be used automatically.
{
  -- First-level elements are tables describing behavior of a target:
  --
  -- - <suffix> - single character suffix. Used after `[` / `]` in mappings.
  --   For example, with `b` creates `[B`, `[b`, `]b`, `]B` mappings.
  --   Supply empty string `''` to not create mappings.
  --
  -- - <options> - table overriding target options.
  --
  -- See `:h MiniBracketed.config` for more info.

  buffer     = { suffix = 'b', options = {} },
  comment    = { suffix = 'c', options = {} },
  conflict   = { suffix = 'x', options = {} },
  diagnostic = { suffix = 'd', options = {} },
  file       = { suffix = 'f', options = {} },
  indent     = { suffix = 'i', options = {} },
  jump       = { suffix = 'j', options = {} },
  location   = { suffix = 'l', options = {} },
  oldfile    = { suffix = 'o', options = {} },
  quickfix   = { suffix = 'q', options = {} },
  treesitter = { suffix = 't', options = {} },
  undo       = { suffix = 'u', options = {} },
  window     = { suffix = 'w', options = {} },
  yank       = { suffix = 'y', options = {} },
}
```

## Similar plugins

- [tpope/vim-unimpaired](https://github.com/tpope/vim-unimpaired)
