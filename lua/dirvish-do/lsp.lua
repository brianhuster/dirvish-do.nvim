require('dirvish-do.compat')

local M = {}

local lsp = vim.lsp

local function send(method, params)
	local clients = lsp.get_clients()
	if #clients == 0 then
		return
	end

	for _, client in ipairs(clients) do
		if client.supports_method(method) then
			pcall(client.request, method, params, function(err, result)
				if result and result.changes then
					lsp.util.apply_workspace_edit(result)
				end
			end)
		end
	end
end

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

local send_file = function(method, path)
	local uri = vim.uri_from_fname(path)
	local params = {
		files = {
			uri = uri,
		},
	}
	send(method, params)
end

function M.willRenameFiles(old_path, new_path)
	send_rename("workspace/willRenameFiles", old_path, new_path)
end

function M.didRenameFiles(old_path, new_path)
	send_rename("workspace/didRenameFiles", old_path, new_path)
end

function M.willCreateFiles(path)
	send_file("workspace/willCreateFiles", path)
end

function M.didCreateFiles(path)
	send_file("workspace/didCreateFiles", path)
end

function M.willDeleteFiles(path)
	send_file("workspace/willDeleteFiles", path)
end

function M.didDeleteFiles(path)
	send_file("workspace/didDeleteFiles", path)
end

return M
