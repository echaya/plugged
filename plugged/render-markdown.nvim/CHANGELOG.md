# Change Log

## Pre-release

## 7.2.0 (2024-09-26)

### Features

- `pipe_table.cell` value `trimmed` [#175](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/175)
  [c686970](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/c68697085441d03a20eee15d4d78e2e5a771569a)
- configurable padding highlight [#176](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/176)
  [095078d](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/095078d931ce23b544face8ca7b845adf7fad7e9)
- pad setext header lines [75a0a95](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/75a0a9596a91130fae43d3b7c0d6c651645ef1df)
- center headings and code blocks [#179](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/179)
  [0986638](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/0986638b381a4b01eb108bb946f3a67a9eb3d0ec)
  [67288fe](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/67288febca78b7aac8fae9543ef8980237e27d2a)
- integrate with lazy.nvim filetypes [cb9a5e2](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/cb9a5e2412d21c7a89627e0d6da5459acbc0eb9c)
- bullet left & right padding on all lines of items [#181](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/181)
  [3adb9d5](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/3adb9d539a016bc63fee83aa740e38fa4eeab094)
- heading margin / padding based on level [#182](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/182)
  & border virtual option [#183](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/183)
  [aad1a12](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/aad1a1220dc9da5757e3af3befbc7fc3869dd334)
- config command to debug configurations [a9643f4](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/a9643f4377f39f4abf943fbc73be69f33f5f2f1d)
- same buffer in multiple windows [#184](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/184)
  [767707e](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/767707e928389996e8860f03552cf962afb0bfb2)

### Bug Fixes

- window options on alternate buffer switch [#177](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/177)
  [f187721](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/f187721a5381f4443ef97ad1a7c0681a65511d28)
- update when window scrolled [#185](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/185)

### Collaborator Shoutouts

- @Bekaboo

## 7.1.0 (2024-09-19)

### Features

- logging improvements [2b86631](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/2b86631c153e24682a1a2d05e37a0f4f94e9b827)
  [2424693](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/2424693c7a4c79641a7ea1e2a838dbc9238d6066)
- table min width [f84eeae](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/f84eeaebac278e26bd2906fd47747631716a5edb)
- new debug API for development [6f87257](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/6f8725746ecadae0ae5ab3e7a1a445dad6b2e231)
- `render_modes` as a boolean [7493db6](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/7493db6d3fe3f6679549e6020498f72e97cd9b73)
- anti conceal selected range in visual mode [#168](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/168)
  [5ff191f](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/5ff191f0c7457ede2fd30ecf76ab16c65118b4ee)
  [354baf4](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/354baf485370b670bb1c1cd64309438607b0465d)
- disable rendering in diff mode [#169](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/169)
  [01b38dc](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/01b38dcf7d0a99620547651fb59a3ba521ba12d5)
- reload runtime highlights on color scheme change [199cc52](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/199cc52ae970c86a6df843bd634db4dd932be1f0)

### Bug Fixes

- indent with block widths [044f2d6](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/044f2d6d76712de69a79b25a7cd8311cb505a9f4)
- nil buffer state [#171](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/171)
  [#172](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/172)

### Collaborator Shoutouts

- @xudyang1

## 7.0.0 (2024-09-13)

### ⚠ BREAKING CHANGES

- `indent.skip` -> `indent.skip_level` [a028fbe](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/a028fbe8f40b329ced721efba15a59ea31db8651)
  - Renamed within hours of adding

### Features

- add missing obsidian aliases [74b77c7](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/74b77c794d64d9d5a27c2a38ac254d9654fcad1f)
- store components in context, avoids duplicate queries [d228a3c](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/d228a3cb40f9e9687c3142cca1f46c4d3e985f7a)
- improve health check for obsidian.nvim conflict [4d2aea3](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/4d2aea341a5d0bf2a01adc0ad4ecf5d4877e1bd0)
  - anyone using `acknowledge_conflicts` in their config should remove it
- performance getting callouts and checkboxes [5513e28](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/5513e283973627385aec9758b00fc018e3a8303f)
- indent based on heading level rather than nesting [27cc6ce](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/27cc6ce2605a2d42900b02648673a1de9b8cb933)
- configurable starting indent level [cdb58fc](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/cdb58fc97c49a1ab75b35d99183c35b5863e845a)
- configurable heading indents so body is offset [#161](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/161)
  [a028fbe](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/a028fbe8f40b329ced721efba15a59ea31db8651)

### Bug Fixes

- only create foreground when inversing highlight [#154](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/154)
  [12fdb6f](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/12fdb6f6623cb7e20da75be68858f12e1e578ffd)
- leading spaces in checkbox bullet [#158](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/158)
  [06337f6](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/06337f64367ef1f1115f0a9ba41e49b84a04b1a4)
- heading borders with indentation [#164](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/164)
- indenting heading borders with single empty line between [2ddb145](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/2ddb145c9e60267a723083b5966189b13febc72b)

### Collaborator Shoutouts

- @lukas-reineke

## 6.3.0 (2024-08-29)

### Features

- integrate treesitter injections [#141](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/141)
  [5ff9a59](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/5ff9a598622422100280769147ad5feff411c6da)
- email link icon [74502e5](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/74502e5d34efa68dde051bcc6bf28db9748922c7)
- deterministic custom link order [#146](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/146)
  [42dbd09](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/42dbd097d73d8c833f886f35ca3be2065973c628)
- setext headings [27d72d7](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/27d72d75035c0430d671f8295ca53c71c4a04633)

### Bug Fixes

- tables indented and no spaces in cells [#142](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/142)
  [a3617d6](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/a3617d61fcf4cec623ee6acb48570589d7ddcb03)
- skip tables with errors [c5f25ef](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/c5f25ef19ed9bb3da4e7d947c5119cf8a6191beb)
- render table border below delimiter when no rows [631e03e](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/631e03e2cfc153c38327c9cc995f4e7c2bbd9b24)
- nil check current line [92e1963](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/92e1963d1ff789bfd4e62867fbcb06fe3c67124e)

## 6.2.0 (2024-08-21)

### Features

- handle imperfectly spaced tables using max width [166a254](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/166a254aaf5b4333fe015a29a66ad99c276538ea)
- anti-conceal margin [abc02f3](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/abc02f35cd6cb28e9b8eb37c88fc863a546367bf)
- log error when mark is skipped [#132](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/132)
  [7986be4](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/7986be47531d652e950776536987e01dd5b55b94)
- checkbox: position [#140](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/140)
  [275f289](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/275f28943ab9ce6017f90bab56c5b5b3c651c269)
- code: independent language padding [#131](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/131)
  [739d845](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/739d8458d6c5742fbcf96a5961b88670fefa1d53)
- full filetype overrides [952b1c0](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/952b1c077a5967f91228f57a6a4979f86386f3c4)
- basic org-indent-mode behavior [#134](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/134)
  [277ae65](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/277ae65ab14c23525ce3dbc9b812244c1976049e)

### Bug Fixes

- wiki links nested in tables [72688ba](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/72688baea4ef0ed605033bf654b54d801b6a5f01)
- code block background when indented in lists [#133](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/133)
  [4c823b1](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/4c823b1df151dbf1ed3ddaacac517be606b1e145)
  [d1cec33](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/d1cec33f0d59bac5c2854312d2ea0483b44dfd11)
- do not set noref in vim.deepcopy [#139](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/139)
- gate virt_text_repeat_linebreak to neovim >= 0.10.0 [98f9965](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/98f996563591b753470942165d2d5134df868529)
- account for folds when computing visible range [#138](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/138)
  [cd0a5ad](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/cd0a5ad8c77c3754d02437048bc0bb604a2fe268)

### Collaborator Shoutouts

- @P1roks
- @Biggybi

## 6.1.0 (2024-08-11)

### Features

- created wiki with examples [here](https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki)
- code block: min_width [4b80b4f](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/4b80b4fb8f81dc39da23a13a0b4e971731c5f849)
- list bullet: left_pad [e455c4f](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/e455c4f4886d250bd610165a24524da2c6adce80)
- preset: obsidian & lazy [96988cc](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/96988cc76414a2f69a57c5dbaca7bf9336c9cb52)
- pipe table: preset round [c4eb6bf](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/c4eb6bf30525fdc7efaf5f33bcb0fa9491ace245)
  - double & heavy [3bacd99](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/3bacd9903e3b4f81b918380a0f170be6713a4da1)
- heading: left_pad, right_pad, & min_width [#121](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/121)
  [6392a5d](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/6392a5dfa10f367e10fe58ea9c2faf3179b145d5)
- heading: border [#123](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/123)
  [b700269](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/b7002694a7a794f8d8a6a0cc54769628cf1cf9d8)
- heading: width based on level [#126](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/126)
  [f06d19a](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/f06d19ad58e4977f02f7885ea00c3ecfdfe609ff)

### Bug Fixes

- same buffer in multiple windows [#122](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/122)
  [1c7b5ee](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/1c7b5ee30d8cf6e52628862dbd06f2e23ecb888e)
- link icon in headings [#124](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/124)
  [f365cef](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/f365cef5c1d05fd2dd390e1830d5c41f2d1f2121)
- provide patch for previous [LuaRock](https://luarocks.org/modules/MeanderingProgrammer/markdown.nvim)
  [v5.0.1](https://github.com/MeanderingProgrammer/render-markdown.nvim/releases/tag/v5.0.1)

## 6.0.0 (2024-08-05)

### ⚠ BREAKING CHANGES

- `custom_handlers` render method deleted and replaced with parse method. The
  former assumed rendering inside, the latter gets marks back so they are not
  interchangeable. Notice of deprecation has been available for a month since
  [726c85c](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/726c85cb9cc6d7d9c85af6ab093e1ee53b5e3c82).
  - Ultimately removed in [83b3865](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/83b386531a0fa67eab1e875f164aff89f560c11b)
  - In order to fix:
    - Implement `parse` method instead of `render`, no direct translation
- Remove `profile` field in favor of benches [dcfa033](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/dcfa033cb39bc4f30019925aa91d3af5ec049614)
  - In order to fix:
    - `profile` field was only meant for development, should not have any users
- Updated buftype options
  - In order to fix:
    - `exclude.buftypes.<v>` -> `overrides.buftype.<v>.enabled = false`
    - `sign.exclude.buftypes.<v>` -> `overrides.buftype.<v>.sign.enabled = false`

### Features

- Performance only parse & render visible range [c7a2055](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/c7a20552b83c2abad92ac5e52feb7fe3b929f0a7)
- Support full buftype options [9a8a2e5](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/9a8a2e5bd204931646f1559235c7c4a7680ecbcd)
- Inline heading position [#107](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/107)
  [345596b](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/345596bb6ef2b0c0a145c59906c2e84dbddfbbd4)
- Pre-compute concealed data once per parse cycle [fcd908b](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/fcd908bafb96e4a30abe7bf8f502790b93ea85ac)
  [3bdae40](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/3bdae400e079a834ae12b658bf1115abf206bb4c)
- Improve table parsing performance by storing state [4d046cd](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/4d046cdf65393a62c0eb209e01574b39f28bc01b)
- Improve performance of showing / hiding marks by storing mark id [ef0c921](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/ef0c921858cbe079d40304200af60b6ce0c99429)
- Hide code block background based on language [#110](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/110)
  [9725df2](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/9725df2306409a836a142244c9eabde96268d730)
- Right aligned code block language hint [#73](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/73)
  [4d8b603](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/4d8b6032b659a45582089de8bcd839f8ccc4161d)
- Obsidian like custom callout titles [#109](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/109)
  [a1bcbf4](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/a1bcbf4858d1834f922029b5fc6ae55a7417bd51)
- Support for wikilinks [e6695b4](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/e6695b4ff330cf9c216fe5e40491cee39d93383a)
- Skip parsing when no text changes and already parsed [#115](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/115)
  [6bb1d43](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/6bb1d43c9e360929d4497a0459084b062bfe9de5)
- Callouts on wrapped lines kind of [#114](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/114)
  [66110dd](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/66110ddfc27b8785f3046dcf516a4f75d6a8f0f9)
- Custom link icons based on destination [#117](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/117)
  [d5b57b3](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/d5b57b32397c0be1f511f4cdf2b876c5b1f01144)

### Bug Fixes

- Repo has been renamed `markdown.nvim` -> `render-markdown.nvim`, one can argue
  this was a long standing bug. Everything internally & externally already used the
  `render markdown` naming convention except for the repo itself. Since Github
  treats the URLs the same and redirects between the 2 there should be no breaking
  changes from this. [aeb5cec](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/aeb5cec617c3bd5738ab82ba2c3f9ccdc27656c2)
  [090ea1e](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/090ea1e9913457fa8848c7afdbfa3b73bb7c7ac8)
- Block code rendering with transparent background [#102](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/102)
- Remove broken reference to `profiler` module [#105](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/105)
  [15d8e02](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/15d8e02663aa58f215ecadbcebbd34149b06a7bc)
- Loading user configuration with vim-plug [#111](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/111)
  [4539c1a](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/4539c1a5d5f961c11bfee7622aa127f4b8a1de16)

### Collaborator Shoutouts

- @scottmckendry

### Awesome Things

- Supported by catppuccin colorscheme [#740](https://github.com/catppuccin/nvim/pull/740)

## 5.0.0 (2024-07-27)

### ⚠ BREAKING CHANGES

- Add additional user command controls to allow lazy loading on command [#72](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/72)
  [3c36a25](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/3c36a257e2a5684b274c1a44fddd64183c7a7507)
- In order to fix:
  - `RenderMarkdownToggle` -> `RenderMarkdown toggle`

### Features

- Full anti-conceal support [726c85c](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/726c85cb9cc6d7d9c85af6ab093e1ee53b5e3c82)
- Link custom highlight groups to better support color schemes [#70](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/70)
  [0f32655](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/0f3265556abf4076170ac0b6a456c67d814ece94)
  [6aa19e9](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/6aa19e9bf36938049e36cd97aafedfe938de8d79)
- Code blocks support block / fixed width [#88](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/88)
- Separate highlight group for inline code blocks [#87](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/87)
- Disable heading icons by setting an empty list [#86](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/86)
- Support full_reference_link nodes [#75](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/75)
  [5879827](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/5879827bc36830dc5516d09e7df1f365ca615047)
- Disable signs per component [#64](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/64)
  [9b771cc](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/9b771cc485677f1aa5873642e33a3522b270225d)
- Improve health check, plugin conflicts, treesitter highlights [#89](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/89)
  [a8a3577](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/a8a35779437e63d930cf69312fe80c3993c80b5b)
  [8d14528](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/8d1452860e1c6b03d814af10024c7edc88e44963)
- Left padding for code blocks [0bbc03c](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/0bbc03c5a208274c89f15c625a0ee3700c9adda8)
- Right padding for list bullets [#93](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/93)
  [2c8be07](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/2c8be07c7760dc7e05b78f88b6ddf8a9f50e410b)
- Fixed width dash [#92](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/92)
  [ff1b449](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/ff1b449bd02ab1a72a4ac9e621c033e335c47863)
- Case insensitive callout matching [#74](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/74)
  [123048b](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/123048b428eb85618780fcef9ea9f4d68b5d2508)
- Improve lazy.nvim instructions [#80](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/80)
- Improve LaTeX compatibility [#90](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/90)
  [695501b](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/695501bd98b1f2ec052889fc4faef24dedd7091b)
- Heading block width [#94](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/94)
  [426b135](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/426b13574c8264636e5660e5f5a3b4f5e3d5a937)
- Alignment indicator for pipe tables [#91](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/91)
  [a273033](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/a27303384570b85ee4538fa5f30eb418fef01ec7)
- Auto-setup using plugin directory [#79](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/79)
  [67bdd9b](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/67bdd9b68c6519bf1d5365f10c96107032bb4532)
- Upload to LuaRocks [#78](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/78)

### Bug Fixes

- Rendering for buffers with no cached marks [#65](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/65)
  [#66](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/66) [4ab8359](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/4ab835985de62b46b6785ae160f5f709b77a0f92)
- Code highlight border with notermguicolors [#77](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/77)
  [#81](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/81)
- Hide cursor row in active buffer only [56d92af](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/56d92af432141346f2d414213726f7a45e82b2b3)
- Remove gifs from repo, fix concel on window change [51eec4e](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/51eec4e4cab69faf7e37c183d23df6b9614952db)
- Wrap get_parser in pcall [#101](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/101)
  [ddb4547](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/ddb454792dd85c0f6039ec14006aecaee67e782d)

### Collaborator Shoutouts

- @folke
- @scottmckendry
- @akthe-at
- @jeremija
- @chrisgrieser
- @Zeioth
- @joshuarayton
- @mrcjkb

### Awesome Things

- Added to LazyVim distribution [#4139](https://github.com/LazyVim/LazyVim/pull/4139)
- Supported by tokyonight.nvim colorscheme [71429c9](https://github.com/folke/tokyonight.nvim/commit/71429c97b7aeafecf333fa825a85eadb21426146)
- Supported by cyberdream.nvim colorscheme [ba25d43](https://github.com/scottmckendry/cyberdream.nvim/commit/ba25d43d68dd34d31bee88286fb6179df2763c31)
- Supported by rose-pine colorscheme [#303](https://github.com/rose-pine/neovim/pull/303)

## 4.1.0 (2024-07-14)

### Features

- Improve handling conealed text for tables, code blocks, and headings. Add 'padded'
  cell style which fills in concealled width. Inline headings when there is no space.
  [#49](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/49) [#50](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/50)
  [9b7fdea](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/9b7fdea8058d48285585c5d82df16f0c829b2384)
  [5ce3566](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/5ce35662725b1024c6dddc8d0bc03befc5abc878)
- Add thin border style for code blocks [#62](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/62)
  [3114d70](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/3114d708283002b50a55be0498668ef838b6c4cf)
- Add icons to images and links [#55](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/55)
  [501e5e0](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/501e5e01493204926aa4e2a12f97b7289636b136)
- Add signs for headings and code blocks [7acc1bf](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/7acc1bf0ecc207411ad6dcf8ecf02f76fe8cbe13)
- Allow signs to be disabled based on buftype, improve highlight color [#58](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/58)
  [#61](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/61) [d398f3e](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/d398f3e9f21d88e1de51594cd4a78f56a3a3eb9e)
- Add defaults for all Obsidian callouts [be3f6e3](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/be3f6e3c6ce38399464a9c3e98309901c06ca80e)
- Add code style 'language', adds icon without background [#52](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/52)
  [308f9a8](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/308f9a826e371e33512234e4604cf581fe1d4ef8)
  [e19ed93](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/e19ed93d75216f8535ede4d401e56ef478856861)
- Allow table border to be configured [b2da013](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/b2da01328e8c99fc290c296886f2653315b73618)
- Improved health check configurable buftype exclude [1d72b63](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/1d72b6356dbb48731b02bce0bc48774f08a47179)
- Use more common heading highlights [e099bd8](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/e099bd80ee286f491c9767cda7614233295aced0)
- Allow each component to be individually disabled [b84a788](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/b84a788f51af7f0905e2351061b3429fa72254b6)

### Bug Fixes

- Account for leading spaces in code blocks [#60](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/60)
  [48083f8](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/48083f81aa1100293b92755a081764f61dce2f1f)
- Use concealled text width for 'raw' table cell style [8c71558](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/8c71558a1cf959c198bb0540a16ae09e93cead62)

## 4.0.0 (2024-07-08)

### ⚠ BREAKING CHANGES

- Group properties by component [a021d5b](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/a021d5b502dcccd28412102f01d0ecd8ef791bd4)
- If you want to punt dealing with these changes feel free to use the `v3.3.1` tag
- In order to fix:
  - `start_enabled` -> `enabled`
  - Latex
    - `latex_enabled` -> `latex.enabled`
    - `latex_converter` -> `latex.converter`
    - `highlights.latex` -> `latex.highlight`
  - Headings
    - `headings` -> `heading.icons`
    - `highlights.heading.backgrounds` -> `heading.backgrounds`
    - `highlights.heading.foregrounds` -> `heading.foregrounds`
  - Code
    - `code_style` -> `code.style`
    - `highlights.code` -> `code.highlight`
  - Dash
    - `dash` -> `dash.icon`
    - `highlights.dash` -> `dash.highlight`
  - Bullets
    - `bullets` -> `bullet.icons`
    - `highlights.bullet` -> `bullet.highlight`
  - Checkbox
    - `checkbox.unchecked` -> `checkbox.unchecked.icon`
    - `highlights.checkbox.unchecked` -> `checkbox.unchecked.highlight`
    - `checkbox.checked` -> `checkbox.checked.icon`
    - `highlights.checkbox.checked` -> `checkbox.checked.highlight`
  - Quote
    - `quote` -> `quote.icon`
    - `highlights.quote` -> `quote.highlight`
  - Table
    - `table_style` -> `pipe_table.style`
    - `cell_style` -> `pipe_table.cell`
    - `highlight.table.head` -> `pipe_table.head`
    - `highlight.table.row` -> `pipe_table.row`
  - Callouts
    - `callout.note` -> `callout.note.rendered`
    - `callout.tip` -> `callout.tip.rendered`
    - `callout.important` -> `callout.important.rendered`
    - `callout.warning` -> `callout.warning.rendered`
    - `callout.caution` -> `callout.caution.rendered`
    - `highlights.callout.note` -> `callout.note.highlight`
    - `highlights.callout.tip` -> `callout.tip.highlight`
    - `highlights.callout.important` -> `callout.important.highlight`
    - `highlights.callout.warning` -> `callout.warning.highlight`
    - `highlights.callout.caution` -> `callout.caution.highlight`
    - `callout.custom.*` -> `callout.*` (i.e. unnest from custom block)
  - Others
    - Any remaing changes are covered within that component.
    - I.e. `code_style` is covered in Code, `highlights.table` is covered in
      Table, `highlights.callout.note` is covered in Callouts, etc.

## 3.3.1 (2024-07-08)

### Features

- Improved health check [7b8110b](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/7b8110b675766810edcbe665f53479893b02f989)
- Use lua to document components [d2a132e](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/d2a132e8ad152a3ab7a92012b0b8bf31dcb6344b)

## 3.3.0 (2024-07-06)

### Features

- Improve performance by attaching events at buffer level [#45](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/45)
  [14b3a01](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/14b3a01fbd7de25b03dafad7398e4ce463a4d323)
- Reduce startup time by scheduling treesitter parsing [6d153d7](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/6d153d749b9297c0e5cb74716f2a8aacc8df3d0e)
- Support arbitrary nesting of block quotes & code blocks [770f7a1](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/770f7a13515b9fd8d4ed4d6a1d8a854b3fbeeb7e)
- Prefer `mini.icons` for code blocks over `nvim-web-devicons` [353e445](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/353e4459938dd58873772e27a45c1d92bc83bafc)
- Support custom checkbox states [#42](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/42)
  [ff3e8e3](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/ff3e8e344004bd6acda48a59f6780b5326e8a453)
- Support custom callouts [8f5bbbd](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/8f5bbbd9e29508e2fc15b6fa9228eada15fca08a)

### Bug Fixes

- Fix language selection logic for code blocks [#44](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/44)
  [90072fd](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/90072fdbc28042add4cd08bef282df032bf6ac42)

## 3.2.0 (2024-06-28)

### Features

- Make default icons consistent [#37](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/37)
  [7cfe1cf](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/7cfe1cfa3b77f6be955f10f0310d5148edc69688)
- Document known limitations [#34](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/34)
  [#35](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/35)
  [0adb35c](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/0adb35cc190d682d689a1a8415d5980c92708403)
- Add troubleshooting guide [#38](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/38)
  [6208fc4](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/6208fc408d444024f5977ea02b83dea8fe177cfa)
- Add note for `vimwiki` users [#39](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/39)
  [56ba207](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/56ba207c860fd86250dcfb9d974a2cf67a5792d7)
- Add issue templates [e353f1f](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/e353f1f566195176b54e2af5b321b517ac240102)
- Add `raw` cell style option [#40](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/40)
  [973a5ac](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/973a5ac8a0a7e8721576d144af8ba5f95c057689)
- Allow custom handlers to extend builtins [870426e](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/870426ea7efe3c0494f3673db7b3b4cb26135ded)
- Add language icon above code blocks [6eef62c](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/6eef62ca1ef373943ff812d4bece94477c3402f2)
- Use full modes instead of truncated values, support pending operation [#43](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/43)
  [467ad24](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/467ad24c4d74c47f6ad346966a577f87f041f0e7)

### Bug Fixes

- Get mode at time of event instead of callback execution [#36](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/36)
  [b556210](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/b556210e6c8759b7d23d5bc74c84aaafe2304da4)
- Update health check to work with neovim 0.9.5 [64969bc](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/64969bc94a9d633dc23b59a382cab407c99fecb1)
- Handle block quotes with empty lines [#41](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/41)
  [6f64bf6](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/6f64bf645b817ff493a28925b1872a69d07fc094)

### Contributor Shoutouts

- @AThePeanut4

## 3.1.0 (2024-06-05)

### Features

- Add debug statements to `latex` handler, make converter configurable [7aedbde](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/7aedbde39ab236d27096a8f8846235af050dbd7f)
- Split demo into separate files [ea465a6](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/ea465a6656e70beeeb6923e21a62f90643b4808f)
- Support highlighting callout quote marker based on callout [#24](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/24)
  [3c6a0e1](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/3c6a0e1914756809aa6ba6478cd60bda6a2c19ef)
- Add health check for `latex` requirements [#32](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/32)
  [a2788a8](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/a2788a8c711539d9425a96e413a26b67eba60131)

## 3.0.0 (2024-05-31)

### ⚠ BREAKING CHANGES

- Allow all window options to be configurable between rendered and non rendered view
  [#31](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/31)
  [258da4b](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/258da4bcdecdc83318a515fc4c6c3e18c0c65a61)
- In order to fix:
  - `conceal = { default = <v1>, rendered = <v2> }` ->
    `win_options = { conceallevel = { default = <v1>, rendered = <v2> } }`

### Contributor Shoutouts

- @masa0x80

## 2.1.0 (2024-05-31)

### Features

- Support github markdown callout syntax [#20](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/20)
  [43bbefd](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/43bbefd410333a04baf62ddfa8bb2a2d30a1bbc1)
- Add health check on treesitter highlights being enabled [#28](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/28)
  [c1d9edc](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/c1d9edc2f2690ef326bd8afbe7fc080412cbb224)
- Script logic to update state config class and README from init.lua [d1cd854](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/d1cd8548dbe139657275e31bcc54f246e86c5ce3)
- Validate user config in health check [6f33a30](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/6f33a30f73783bb10900cb2f9468f314cad482b4)
- Support user defined handlers [#30](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/30)
  [473e48d](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/473e48dd0913d2e83610c86c5143a07fd7e60d4e)

### Bug Fixes

- Use strdisplaywidth in all string length calculations [#26](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/26)
  [7f90f52](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/7f90f522750111c32b0515814398514d58f66b23)

## 2.0.0 (2024-05-21)

### ⚠ BREAKING CHANGES

- Allow multiple kinds of table highlight behaviors [#21](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/21)
  [49f4597](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/49f45978fbb8fcf874f3b6967db4a6ea647df04b)
- In order to fix:
  - `fat_tables = true` -> `table_style = 'full'`
  - `fat_tables = false` -> `table_style = 'normal'`

## 1.2.0 (2024-05-21)

### Features

- Add simple logging [467c135](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/467c13523153f9b918c86037d0b5f2a37094cb88)
- Make start state configurable [#16](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/16)
  [#17](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/17)
- Add unit / kinda integ test [b6c4ac7](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/b6c4ac787b357493e75854354329a2442475fcc1)
- Add packer.nvim setup to README [#19](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/19)
  [9376997](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/93769977e0821a74bed797c2a589a4956200d497)
- Update for 0.10.0 (no user impact) [0581a9a](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/0581a9add614cddbc442d6b483139e43e46c1f0e)
- Disable rendering on large files [e96f40d](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/e96f40d85be763427b00d8a541cf3389b110431f)
- Operate at event buffer level rather than current buffer [41b955c](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/41b955c45db3602169c567546744fafdd43c27b9)

### Bug Fixes

- Fix bullet point rendering with checkbox [#18](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/18)
  [#22](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/22)
  [e38795f](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/e38795f3641ffb5702bf289f76df8a81f6163d32)
- Disable plugin on horizontal scroll [#23](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/23)
  [966472e](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/966472e123195cb195e7af49d7db248ce104bee8)

### Contributor Shoutouts

- @cleong14
- @dvnatanael

## 1.1.0 (2024-04-13)

### Features

- Configurable file types [d7d793b](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/d7d793baf716db965e6f4f4cc0d14a640300cc26)
- Add toggle command [#4](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/4)
  [fea6f3d](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/fea6f3de62d864633ffe4e1e0fd92d1e746f77ed)
- Use buffer parser to handle injections [#3](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/3)
  [e64255d](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/e64255d52dcdf05eb37d9e93fbfd300648c4c4dd)
- Add LaTeX support [#6](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/6)
  [138a796](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/138a7962fcbe9cddcb47cc40a58ec0f5ab99ddfe)
  [da85a5e](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/da85a5e5885f1a11ab2b7a9059c16f3eede89bfe)
- Support block quotes [106946a](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/106946ae924706c885bda14a9160398e79880f30)
- Make icons bigger for certain font setups [#19](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/9)
  [38f7cbc](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/38f7cbcc0024737901ba87ee8bf1a6d466f99774)
- Support inline code [df59836](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/df5983612081397293c1e573c91de33639f2bbe6)
- Dynamic conceal level [#10](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/10)
  [c221998](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/c2219984fa1ddc5d3f6a76c1c1ad0744aa9f9011)
- Add Vimdoc [cdc58f5](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/cdc58f576582ab524192eca5611f05dbe2b6b609)
- Add fat tables option [fb00297](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/fb00297774c6f44c0cc3346459ed85168ac93dce)
- Support list icon based on level [#1](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/1)
  [#11](https://github.com/MeanderingProgrammer/render-markdown.nvim/pull/11)
- Refactor + LaTeX cache [2b98d16](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/2b98d16f938dc9cedaa5f1c0659081035655f781)
- Support horizontal break [af819f3](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/af819f39c63aeb09ff3801dbfd5188cea55e48e7)
- Support checkboxes [90637a1](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/90637a1120de47a3be57b00b7db4eee0d24834c8)

### Bug Fixes

- Leading spaces in list [#2](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/2)
  [#5](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/5)
  [df98da8](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/df98da81375e5dc613c3b1eaa915a847059d48d9)
- Passing custom query does not work [#7](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/7)
  [70f8f4f](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/70f8f4f64d529d60730d6462af180bbec6f7ef18)
- Ignore ordered lists for bullet points [#7](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/7)
  [f5917d2](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/f5917d2113ce2b0ce8ce5b24cfbd7f45e0ec5e67)
- Dynamic heading padding [#12](https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/12)
  [a0da7cf](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/a0da7cfe61dd1a60d9ca6a57a72ae34edb64dbc9)

### Contributor Shoutouts

- @lkhphuc
- @redimp
- @shabaev

## 1.0.0 (2024-03-21)

### ⚠ BREAKING CHANGES

- Changes folder from `markdown` to `render-markdown` to reduce chances of name
  collision in require statements [07685a1](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/07685a1838ad3f4e653a021cde5c7ff67224869f)
- In order to fix:
  - `require('markdown')` -> `require('render-markdown')`

## 0.0.1 (2024-03-21)

### Features

- Support rendering headings & code blocks [4fb7ea2](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/4fb7ea2e380dd80085936e9072ab851d2174e1b0)
- Mode based rendering [3fd818c](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/3fd818ccfbb57a560d8518e92496142bc644cb80)
- Supprt rendering tables [fe2ebe7](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/fe2ebe78ffc3274e681bd3f2de6fec0ed233db52)
- Add basic health check [b6ea30e](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/b6ea30ef6b7ba6bfbe3c5ec55afe0769026ff386)
- Customize icon based on heading level [208599b](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/208599b0ca2c3daac681cf777ff3be248c67965b)
- Create auto demo script [03a7c00](https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/03a7c0044b7e85903f3b0042d600568c37246120)