local M = {}

local fs = vim.fs
local fn = vim.fn
local uv = vim.uv or vim.loop
local lsp = require('dirvish-do.lsp')
local api = vim.api

---@type string
M.sep = fn.exists('+shellslash') == 1 and not vim.o.shellslash and '\\' or '/'

--- Run a command with sudo. Will prompt for password.
--- Use |v:shell_error| to check if the command was successful.
---@param cmd string|string[]
function M.sudo_exec(cmd)
	local password = fn.inputsecret("Password: ")
	if #password == 0 then
		vim.notify("No password provided", vim.log.levels.ERROR)
		return
	end
	local sudo_cmd = { 'sudo', '-p', '', '-S', 'sh', '-c' }
	if type(cmd) == 'table' then
		assert(vim.islist(cmd), 'cmd table must be a list')
		sudo_cmd = vim.list_extend(sudo_cmd, cmd)
	elseif type(cmd) == 'string' then
		table.insert(sudo_cmd, cmd)
	else
		error('cmd must be a string or a list')
	end
	local result = fn.system(sudo_cmd, password)
	if vim.v.shell_error ~= 0 then
		vim.notify(result, vim.log.levels.ERROR)
	end
	return result
end

---@param bufnr number : Buffer number, or 0 for current buffer
---@param filename string?
function M.sudo_write(bufnr, filename)
	filename = filename or api.nvim_buf_get_name(bufnr)
	local tempname = fn.tempname()
	fn.writefile(api.nvim_buf_get_lines(0, 0, -1, true), tempname)
	local cmd = { 'dd', 'if=' .. tempname, 'of=' .. filename, 'bs=' .. 2 ^ 20 }
	require('dirvish-do.operations').sudo_exec(cmd)
	if vim.v.shell_error == 0 then
		print(filename .. ' written')
	end
end

---@param path string
function M.mkdir(path)
	if vim.g.dirvish_sudo then
		M.sudo_exec({ 'mkdir', '-p', path })
		return vim.v.shell_error == 0
	end
	local success = fn.mkdir(path, 'p')
	return success == 1
end

---@param path string
function M.rm(path)
	if require('dirvish-do').config.operations.remove == 'trash' then
		M.trash(path)
		return
	end
	local isDir = path:sub(-1) == M.sep
	if vim.g.dirvish_sudo then
		local cmd = isDir and { 'rm', '-rf' } or { 'rm' }
		M.sudo_exec(vim.list_extend(cmd, { path }))
		return
	end

	if fs.rm then
		fs.rm(path, isDir and { recursive = true })
	else
		local fail = fn.delete(path, isDir and 'rf' or nil)
		if fail ~= 0 then
			vim.notify(string.format("Failed to delete %s", path), vim.log.levels.ERROR)
		end
	end
end

---@param file string
---@param newpath string
function M.copyfile(file, newpath)
	if vim.g.dirvish_sudo then
		M.sudo_exec({ 'cp', file, newpath })
		return vim.v.shell_error == 0
	end
	local success, errname, errmsg = uv.fs_copyfile(file, newpath)
	if not success then
		vim.notify(string.format("%s: %s", errname, errmsg), vim.log.levels.ERROR)
	end
	return success
end

-- Copy dir recursively
---@param dir string
---@param newpath string
function M.copydir(dir, newpath)
	local handle = uv.fs_scandir(dir)
	if not handle then
		return
	end
	if vim.g.dirvish_sudo then
		M.sudo_exec({ 'cp', '-r', dir, newpath })
		return vim.v.shell_error == 0
	end
	local success, errname, errmsg = uv.fs_mkdir(newpath, 493)
	if not success then
		vim.notify(string.format("%s: %s", errname, errmsg), vim.log.levels.ERROR)
		return
	end

	while true do
		local name, type = uv.fs_scandir_next(handle)
		if not name then
			break
		end
		local filepath = fs.joinpath(dir, name)
		if type == "directory" then
			M.copydir(filepath, fs.joinpath(newpath, name))
		elseif type == "file" then
			M.copyfile(filepath, fs.joinpath(newpath, name))
		elseif type == "link" then
			M.copylink(filepath, fs.joinpath(newpath, name))
		end
	end
end

---@param oldpath string
---@param newpath string
function M.copylink(oldpath, newpath)
	local target = uv.fs_readlink(oldpath)
	if target then
		if vim.g.dirvish_sudo then
			M.sudo_exec({ 'cp', oldpath, newpath })
			return vim.v.shell_error == 0
		end
		uv.fs_symlink(target, newpath)
	end
end

---@param oldPath string
---@param newPath string
---@return boolean|nil, string|nil, string|nil
function M.mv(oldPath, newPath)
	lsp.willRenameFiles(oldPath, newPath)
	if vim.g.dirvish_sudo then
		M.sudo_exec({ 'mv', oldPath, newPath })
		return vim.v.shell_error == 0, '', ''
	end
	local success, errname, errmsg = uv.fs_rename(oldPath, newPath)
	lsp.didRenameFiles(oldPath, newPath)
	return success, errname, errmsg
end

---@param path string
function M.trash(path)
	local py3cmd = string.format('from send2trash import send2trash; send2trash("%s")', path)
	vim.cmd.python3(py3cmd)
end

return M
