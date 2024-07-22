for /d /r . %%d in (.git) do if exist "%%d" if "%%~pd" NEQ "\PluggedRepo\" rd /s/q "%%d"
for /d /r . %%d in (.github) do if exist "%%d" rd /s/q "%%d"
lazygit
