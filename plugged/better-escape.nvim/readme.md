# better-escape.nvim

![better-escape](https://github.com/max397574/better-escape.nvim/assets/81827001/8863a620-b075-4417-92d0-7eb2d2646186)

A lot of people have mappings like `jk` or `jj` to escape insert mode. The
problem with this mappings is that whenever you type a `j`, neovim wait about
100-500ms (depending on your timeoutlen) to see, if you type a `j` or a `k`
because these are mapped. Only after that time the `j` will be inserted. Then
you always get a delay when typing a `j`.

An example where this has a big impact is e.g. telescope. Because the characters
which are mapped aren't really inserted at first the whole filtering isn't
instant.

![better-escape-tele](https://github.com/max397574/better-escape.nvim/assets/81827001/390f115d-87cd-43d8-aadf-fffb12bd84c9)

## ✨Features

- Write mappings in many modes without having a delay when typing
- Customizable timeout
- Map key sequences and lua functions
- Use multiple mappings
- Really small and fast

## 📦Installation

Use your favourite package manager and call the setup function.

```lua
-- lua with lazy.nvim
{
  "max397574/better-escape.nvim",
  config = function()
    require("better_escape").setup()
  end,
}
```

## ❗Rewrite

There was a big rewrite which allows much more flexibility now. You can now
define mappings in most modes and also use functions.

The biggest change was that the `mapping` config option was removed. Check the
default configuration below to see the new structure.

This also deprecated the `clear_empty_lines` setting. You can replicate this
behavior by setting a mapping to a function like this:

```lua
-- `k` would be the second key of a mapping
k = function()
    vim.api.nvim_input("<esc>")
    local current_line = vim.api.nvim_get_current_line()
    if current_line:match("^%s+j$") then
        vim.schedule(function()
            vim.api.nvim_set_current_line("")
        end)
    end
end
```

## ⚙️Customization

Call the setup function with your options as arguments.

After the rewrite you can also use any function. So you could for example map
`<space><tab>` to jump with luasnip like this:

```lua
i = {
    [" "] = {
        ["<tab>"] = function()
            -- Defer execution to avoid side-effects
            vim.defer_fn(function()
                -- set undo point
                vim.o.ul = vim.o.ul
                require("luasnip").expand_or_jump()
            end, 1)
        end
    }
}
```

### Disable mappings
To disable keys set them to `false` in the configuration.
You can also disable all default mappings by setting the `default_mappings` option to false.

<details>
<summary>Default Config</summary>

```lua
-- lua, default settings
require("better_escape").setup {
    timeout = vim.o.timeoutlen,
    default_mappings = true,
    mappings = {
        i = {
            j = {
                -- These can all also be functions
                k = "<Esc>",
                j = "<Esc>",
            },
        },
        c = {
            j = {
                k = "<Esc>",
                j = "<Esc>",
            },
        },
        t = {
            j = {
                k = "<C-\\><C-n>",
            },
        },
        v = {
            j = {
                k = "<Esc>",
            },
        },
        s = {
            j = {
                k = "<Esc>",
            },
        },
    },
}
```

</details>

## API

`require("better_escape").waiting` is a boolean indicating that it's waiting for
a mapped sequence to complete.

<details>
<summary>Statusline example</summary>

```lua
function escape_status()
  local ok, m = pcall(require, 'better_escape')
  return ok and m.waiting and '✺' or ""
end
```

</details>

## ❤️ Support

If you like the projects I do and they can help you in your life you can support
my work with [github sponsors](https://github.com/sponsors/max397574). Every
support motivates me to continue working on my open source projects.

## Similar plugins

The old version of this plugin was a lua version of
[better_escape.vim](https://github.com/jdhao/better-escape.vim), with some
additional features and optimizations. This changed with the rewrite though. Now
it has much more features.
