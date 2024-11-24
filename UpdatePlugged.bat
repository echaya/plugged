@echo on
for /d /r . %%d in (plugged) do @if exist "%%d" rd /s/q "%%d"

SET MoveToDir=D:\Workspace\PluggedRepo\plugged
SET MoveFromDir=d:\Dropbox\neovim\plugged
ROBOCOPY %MoveFromDir% %MoveToDir% /S

for /d /r . %%d in (.git) do if exist "%%d" if "%%~pd" NEQ "\Workspace\PluggedRepo\" rd /s/q "%%d"
for /d /r . %%d in (.github) do if exist "%%d" rd /s/q "%%d"
for /r "%MoveToDir%" %%f in (*.jpg, *.png, *.gif, *.bmp, *.tiff, *.svg) do del "%%f"

del d:\Workspace\PluggedRepo\plugged\nvim-treesitter\parser-info\.gitignore
del d:\Workspace\PluggedRepo\plugged\nvim-treesitter\parser\.gitignore
del d:\Workspace\PluggedRepo\plugged\telescope-fzf-native.nvim\.gitignore

lazygit
:: cmd /k
