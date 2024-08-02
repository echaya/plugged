@echo
mkdir plugged\markdown-preview.nvim\app\bin
copy plugged-old\markdown-preview.nvim\app\bin\markdown-preview-win.exe plugged\markdown-preview.nvim\app\bin
mkdir plugged\telescope-fzf-native.nvim\build
copy plugged-old\telescope-fzf-native.nvim\build\libfzf.dll plugged\telescope-fzf-native.nvim\build
cmd /k
