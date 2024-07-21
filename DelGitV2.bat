@ECHO ON

SET MoveToDir=D:\tempgitforplugged
SET MoveFromDir=D:\temp\\.git

ROBOCOPY %MoveFromDir% %MoveToDir% /S

for /d /r . %%d in (.git) do @if exist "%%d" rd /s/q "%%d"
for /d /r . %%d in (.github) do @if exist "%%d" rd /s/q "%%d"

ROBOCOPY %MoveToDir% %MoveFromDir% /S
CD D:\
for /d /r . %%d in (tempgitforplugged) do @if exist "%%d" rd /s/q "%%d"
::RD /S %MoveToDir%
RMDIR %MoveToDir%
cmd /k
