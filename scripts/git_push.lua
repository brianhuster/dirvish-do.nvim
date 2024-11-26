#!/usr/bin/env -S nvim -l
vim.cmd [[
!git add .
exec "!git commit -m '".luaeval('_G.arg[1]')."'"
!git pull --rebase
!git push
]]
