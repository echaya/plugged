local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'veryl-ls' },
    filetypes = { 'veryl' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/veryl-lang/veryl

Language server for Veryl

`veryl-ls` can be installed via `cargo`:
 ```sh
 cargo install veryl-ls
 ```
    ]],
  },
}
