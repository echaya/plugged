# 🍿 gitbrowse

Open the repo of the active file in the browser (e.g., GitHub)

<!-- docgen -->

## ⚙️ Config

```lua
---@class snacks.gitbrowse.Config
{
  -- Handler to open the url in a browser
  ---@param url string
  open = function(url)
    if vim.fn.has("nvim-0.10") == 0 then
      require("lazy.util").open(url, { system = true })
      return
    end
    vim.ui.open(url)
  end,
  ---@type "repo" | "branch" | "file" | "commit"
  what = "file", -- what to open. not all remotes support all types
  -- patterns to transform remotes to an actual URL
  remote_patterns = {
    { "^(https?://.*)%.git$"              , "%1" },
    { "^git@(.+):(.+)%.git$"              , "https://%1/%2" },
    { "^git@(.+):(.+)$"                   , "https://%1/%2" },
    { "^git@(.+)/(.+)$"                   , "https://%1/%2" },
    { "^ssh://git@(.*)$"                  , "https://%1" },
    { "^ssh://([^:/]+)(:%d+)/(.*)$"       , "https://%1/%3" },
    { "^ssh://([^/]+)/(.*)$"              , "https://%1/%2" },
    { "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
    { "^https://%w*@(.*)"                 , "https://%1" },
    { "^git@(.*)"                         , "https://%1" },
    { ":%d+"                              , "" },
    { "%.git$"                            , "" },
  },
  url_patterns = {
    ["github%.com"] = {
      branch = "/tree/{branch}",
      file = "/blob/{branch}/{file}#L{line}",
      commit = "/commit/{commit}",
    },
    ["gitlab%.com"] = {
      branch = "/-/tree/{branch}",
      file = "/-/blob/{branch}/{file}#L{line}",
      commit = "/-/commit/{commit}",
    },
    ["bitbucket%.org"] = {
      branch = "/src/{branch}",
      file = "/src/{branch}/{file}#lines-{line}",
      commit = "/commits/{commit}",
    },
  },
}
```

## 📦 Module

### `Snacks.gitbrowse()`

```lua
---@type fun(opts?: snacks.gitbrowse.Config)
Snacks.gitbrowse()
```

### `Snacks.gitbrowse.get_url()`

```lua
---@param repo string
---@param opts? snacks.gitbrowse.Config
Snacks.gitbrowse.get_url(repo, opts)
```

### `Snacks.gitbrowse.open()`

```lua
---@param opts? snacks.gitbrowse.Config
Snacks.gitbrowse.open(opts)
```
