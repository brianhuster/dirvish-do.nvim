local M = {}

local fs = vim.fs
local fn = vim.fn
local uv = vim.uv or vim.loop
local lsp = require('dirvish-do.lsp')

M.sep = fn.exists('+shellslash') and not vim.o.shellslash and '\\' or '/'

function M.rm(path)
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

function M.copyfile(file, newpath)
	local success, errname, errmsg = uv.fs_copyfile(file, newpath)
	if not success then
		vim.print(string.format("%s: %s", errname, errmsg), vim.log.levels.ERROR)
	end
end

-- Copy dir recursively
function M.copydir(dir, newpath)
	local handle = uv.fs_scandir(dir)
	if not handle then
		return
	end
	local success, errname, errmsg = uv.fs_mkdir(newpath, 493)
	if not success then
		vim.print(string.format("%s: %s", errname, errmsg), vim.log.levels.ERROR)
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

function M.mv(oldPath, newPath)
	lsp.willRenameFiles(oldPath, newPath)
	local success, errname, errmsg = uv.fs_rename(oldPath, newPath)
	lsp.didRenameFiles(oldPath, newPath)
	return success, errname, errmsg
end

return M
