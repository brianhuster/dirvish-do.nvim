local health = vim.health
local M = {}

function M.check()
	health.start('Check requirements')
	if vim.fn.has('nvim-0.8') == 0 then
		health.error('dirvish-dovish.nvim only supports Nvim 0.8 and later')
		return
	end
	health.ok('Your Neovim version is supported')

	if not pcall(vim.fn["dirvish#remove_icon_fn"], -1) then
		health.warn('vim-dirvish not installed',
			'Get it at `https://github.com/justinmk/vim-dirvish`')
	else
		health.ok('vim-dirvish is installed')
	end

	health.start('Check your config')
	health.info(vim.inspect(require('dirvish-do').config))
end

return M
