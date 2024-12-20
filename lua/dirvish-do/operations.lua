local M = {}

local fs = vim.fs
local fn = vim.fn
local uv = vim.uv or vim.loop
local lsp = require('dirvish-do.lsp')

---@type string
M.sep = fn.exists('+shellslash') == 1 and not vim.o.shellslash and '\\' or '/'

function M.sudo_exec(cmd)
	local password = fn.inputsecret("Password: ")
	if #password == 0 then
		vim.notify("No password provided", vim.log.levels.ERROR)
		return
	end
	cmd = 'sudo -p "" -S ' .. cmd
	local result = fn.system(cmd, password)
	if vim.v.shell_error then
		vim.notify(result, vim.log.levels.ERROR)
	end
	return result
end

function M.mkdir(path)
	if vim.g.dirvish_sudo then
		M.sudo_exec('mkdir ' .. path)
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
		local cmd = isDir and 'rm -rf ' or 'rm '
		M.sudo_exec(cmd .. path)
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
		M.sudo_exec('cp ' .. file .. ' ' .. newpath)
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
		M.sudo_exec('cp -r ' .. dir .. ' ' .. newpath)
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
			M.sudo_exec('ln -s ' .. target .. ' ' .. newpath)
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
		M.sudo_exec('mv ' .. oldPath .. ' ' .. newPath)
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
