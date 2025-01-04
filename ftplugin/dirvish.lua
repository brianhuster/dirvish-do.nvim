if vim.fn.has('nvim-0.8') == 0 then
	vim.notify('dirvish-do.nvim only supports Nvim 0.8 and later', vim.log.levels.ERROR)
	return
end

local map = function(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true })
end
local dirvido = require('dirvish-do')
local keymaps = dirvido.config.keymaps

map({ 'n' }, keymaps.copy, dirvido.copy)
map({ 'n' }, keymaps.move, dirvido.move)
map({ 'n' }, keymaps.rename, dirvido.rename)
map({ 'n' }, keymaps.remove, dirvido.nremove)
map({ 'x' }, keymaps.remove, dirvido.vremove)
map({ 'n' }, keymaps.make_file, dirvido.mkfile)
map({ 'n' }, keymaps.make_dir, dirvido.mkdir)
map({ 'v' }, 'y', function()
	vim.fn.setreg(vim.v.register, require 'dirvish-do.utils'.getVisualSelectedLines())
end)
