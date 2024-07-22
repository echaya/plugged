
for /d /r . %%d in (plugged) do @if exist "%%d" rd /s/q "%%d"

SET MoveToDir=D:\PluggedRepo
SET MoveFromDir=d:\Dropbox\neovim\nvim-win64\share\nvim\vimfiles
ROBOCOPY %MoveFromDir% %MoveToDir% /S

for /d /r . %%d in (.git) do if exist "%%d" if "%%~pd" NEQ "\PluggedRepo\" rd /s/q "%%d"
for /d /r . %%d in (.github) do if exist "%%d" rd /s/q "%%d"
lazygit
