# 🍿 bigfile

`bigfile` adds a new filetype `bigfile` to Neovim that triggers when the file is
larger than the configured size. This automatically prevents things like LSP
and Treesitter attaching to the buffer.

Use the `setup` config function to further make changes to a `bigfile` buffer.
The context provides the actual filetype.

The default implementation enables `syntax` for the buffer and disables
[mini.animate](https://github.com/echasnovski/mini.animate) (if used)

<!-- docgen -->

## ⚙️ Config

```lua
---@class snacks.bigfile.Config
{
  notify = true, -- show notification when big file detected
  size = 1.5 * 1024 * 1024, -- 1.5MB
  -- Enable or disable features when big file detected
  ---@param ctx {buf: number, ft:string}
  setup = function(ctx)
    vim.b.minianimate_disable = true
    vim.schedule(function()
      vim.bo[ctx.buf].syntax = ctx.ft
    end)
  end,
}
```
