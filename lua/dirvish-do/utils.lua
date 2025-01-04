local api, fn, M = vim.api, vim.fn, {}

function M.getVisualSelectedLines()
	local line_start = api.nvim_buf_get_mark(0, "<")[1]
	local line_end = api.nvim_buf_get_mark(0, ">")[1]

	if line_start > line_end then
		line_start, line_end = line_end, line_start
	end

	--- Nvim API indexing is zero-based, end-exclusive
	local lines = api.nvim_buf_get_lines(0, line_start - 1, line_end, false)

	return lines
end


function M.get_register()
	local reg = fn.getreg()
	return vim.split(reg, '\n', { trimempty = true })
end

return M
