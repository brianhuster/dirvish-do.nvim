require('dirvish-do.compat')

local M = {}

local lsp = vim.lsp

---@param method string
---@param params table
local function send(method, params)
	local clients = lsp.get_clients()
	if #clients == 0 then
		return
	end

	for _, client in ipairs(clients) do
		if client.supports_method(method) then
			pcall(client.request, method, params, function(err, result)
				if result and result.changes then
					lsp.util.apply_workspace_edit(result, 'utf-8')
				end
			end)
		end
	end
end

---@param method string
---@param old_path string
---@param new_path string
local function send_rename(method, old_path, new_path)
	local old_uri = vim.uri_from_fname(old_path)
	local new_uri = vim.uri_from_fname(new_path)
	local params = {
		files = {
			{
				oldUri = old_uri,
				newUri = new_uri,
			},
		},
	}
	send(method, params)
end

---@param method string
---@param path string
local send_file = function(method, path)
	local uri = vim.uri_from_fname(path)
	local params = {
		files = {
			uri = uri,
		},
	}
	send(method, params)
end

---@param old_path string
---@param new_path string
function M.willRenameFiles(old_path, new_path)
	send_rename("workspace/willRenameFiles", old_path, new_path)
end

function M.didRenameFiles(old_path, new_path)
	send_rename("workspace/didRenameFiles", old_path, new_path)
end

---@param path string
function M.willCreateFiles(path)
	send_file("workspace/willCreateFiles", path)
end

---@param path string
function M.didCreateFiles(path)
	send_file("workspace/didCreateFiles", path)
end

---@param path string
function M.willDeleteFiles(path)
	send_file("workspace/willDeleteFiles", path)
end

---@param path string
function M.didDeleteFiles(path)
	send_file("workspace/didDeleteFiles", path)
end

M.willRenameFiles('lua/dirvish-do/lsp.lua', 'lua/dirvish-do/lsp-itg.lua')

return M
