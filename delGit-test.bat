for /d /r . %%d in (.git) do @if exist "%%d" @if %%~pd NEQ '\temp\' rd /s/q "%%d"
for /d /r . %%d in (.github) do @if exist "%%d" rd /s/q "%%d"
:: for /d /r "D:\temp" %d in (.git) do @if exist "%d" echo "%d"
cmd /k
