local M = {}

local fs = vim.fs
local fn = vim.fn
local uv = vim.uv or vim.loop
local lsp = require('dirvish-do.lsp')

---@type string
M.sep = fn.exists('+shellslash') == 1 and not vim.o.shellslash and '\\' or '/'

---@param path string
function M.rm(path)
	if require('dirvish-do').config.operations.remove == 'trash' then
		M.trash(path)
		return
	end
	local isDir = path:sub(-1) == "/"
	if isDir then
		if fs.rm then
			fs.rm(path, { recursive = true })
		else
			fn.delete(path, 'rf')
		end
	else
		if fs.rm then
			fs.rm(path)
		else
			fn.delete(path)
		end
	end
end

---@param file string
---@param newpath string
function M.copyfile(file, newpath)
	local success, errname, errmsg = uv.fs_copyfile(file, newpath)
	if not success then
		vim.notify(string.format("%s: %s", errname, errmsg), vim.log.levels.ERROR)
	end
end

-- Copy dir recursively
---@param dir string
---@param newpath string
function M.copydir(dir, newpath)
	local handle = uv.fs_scandir(dir)
	if not handle then
		return
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
		else
			M.copyfile(filepath, fs.joinpath(newpath, name))
		end
	end
end

---@param oldPath string
---@param newPath string
---@return boolean|nil, string|nil, string|nil
function M.mv(oldPath, newPath)
	lsp.willRenameFiles(oldPath, newPath)
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
