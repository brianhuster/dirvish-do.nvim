if vim.fn.has('nvim-0.8') == 0 then
	vim.notify('dirvish-do.nvim only supports Nvim 0.8 and later', vim.log.levels.ERROR)
	return
end

local map = vim.keymap.set
local dirvido = require('dirvish-do')
local keymaps = dirvido.config.keymaps

map({ 'n' }, keymaps.copy, dirvido.copy, { buffer = true, silent = true })
map({ 'n' }, keymaps.move, dirvido.move, { buffer = true, silent = true })
map({ 'n' }, keymaps.rename, dirvido.rename, { buffer = true, silent = true })
map({ 'n' }, keymaps.remove, dirvido.nremove, { buffer = true, silent = true })
map({ 'x' }, keymaps.remove, dirvido.vremove, { buffer = true, silent = true })
map({ 'n' }, keymaps.make_file, dirvido.mkfile, { buffer = true, silent = true })
map({ 'n' }, keymaps.make_dir, dirvido.mkdir, { buffer = true, silent = true })
