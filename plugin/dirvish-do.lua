local fn = vim.fn

local command = vim.api.nvim_create_user_command

command('DirvishSudo', function()
	vim.g.dirvish_sudo = not vim.g.dirvish_sudo
	print('Sudo mode for dirvish is ' .. (vim.g.dirvish_sudo and 'enabled' or 'disabled'))
end, {})

-- command('SudoWrite', function()
-- 	local filename = vim.api.nvim_buf_get_name(0)
-- 	local tempname = fn.tempname()
-- 	fn.writefile(fn.getline(1, '$'), tempname)
-- 	local cmd = ('dd if=%s of=%s bs=%d'):format(tempname, filename, 2^20)
-- 	require'dirvish-do.operations'.sudo_exec(cmd)
-- end, {})

if fn.has('nvim-0.10.1') == 1 then
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
end
