local fn = vim.fn

if fn.has('nvim-0.10.1') == 0 then
	return
end

local command = vim.api.nvim_create_user_command

command("Open", function(opts)
	local filename = opts.args
	if not filename then
		return
	end
	local open_cmd = require('dirvish-do').config.open_cmd
	vim.ui.open(filename, open_cmd and { cmd = open_cmd })
end, { nargs = 1, complete = "file" })

command("Launch", function(opts)
	local fargs = opts.fargs
	local cmd = fargs[1]
	if not cmd then
		return
	end
	local path = fargs[2]
	if not path then
		return
	end
	vim.ui.open(path, { cmd = { cmd }, })
end, {
	nargs = "+",
	complete = function(ArgLead, CmdLine, CursorPos)
		local executable = vim.split(CmdLine, " ")[2]
		if executable == ArgLead then
			return fn.getcompletion(ArgLead, "shellcmd")
		else
			return fn.getcompletion(ArgLead, "file")
		end
	end
})

command('DirvishSudo', function()
	vim.g.dirvish_sudo = not vim.g.dirvish_sudo
	print('Sudo mode for dirvish is ' .. (vim.g.dirvish_sudo and 'enabled' or 'disabled'))
end, {})
