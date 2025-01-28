local command = vim.api.nvim_create_user_command

command('DirvishSudo', function()
	vim.b.dirvish_sudo = not vim.b.dirvish_sudo
	print('Sudo mode for dirvish is ' .. (vim.b.dirvish_sudo and 'enabled' or 'disabled'))
end, {})
