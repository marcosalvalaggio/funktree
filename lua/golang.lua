local function golang(root_lines, buf)
	local func_pattern = "func%s+([A-Za-z][A-Za-z0-9]*)"
	local method_pattern = "func%s*%([^)]*%)%s+([A-Za-z][A-Za-z0-9]*)%s*%(%s*%)"
	local struct_pattern = "type%s+([A-Za-z][A-Za-z0-9]*)%s+struct"
	local interface_pattern = "type%s+([A-Za-z][A-Za-z0-9]*)%s+interface"
	local comment_pattern = "//"
	local reduced_lines = {}
	local status = false
	for i, line in ipairs(root_lines) do
		local struct_name = line:match(struct_pattern)
		local interface_name = line:match(interface_pattern)
		if struct_name then
			local comment_start, struct_start = line:find(comment_pattern), line:find(struct_pattern)
			if comment_start then
				if comment_start and struct_start and comment_start > struct_start then
					table.insert(reduced_lines, string.format("struct: %s, line: %d", struct_name, i))
					status = true
				end
			else
				table.insert(reduced_lines, string.format("struct: %s, line: %d", struct_name, i))
				status = true
			end
		elseif interface_name then
			local comment_start, interface_start = line:find(comment_pattern), line:find(interface_pattern)
			if comment_start then
				if comment_start and interface_start and comment_start > interface_start then
					table.insert(reduced_lines, string.format("interface: %s, line: %d", interface_name, i))
					status = true
				end
			else
				table.insert(reduced_lines, string.format("interface: %s, line: %d", interface_name, i))
				status = true
			end
		else
			local method_name = line:match(method_pattern)
			if method_name then
				local comment_start, method_start = line:find(comment_pattern), line:find(method_pattern)
				if comment_start then
					if comment_start and method_start and comment_start > method_start then
						table.insert(reduced_lines, string.format("m: %s, line: %d", method_name, i))
						status = true
					end
				else
					table.insert(reduced_lines, string.format("m: %s, line: %d", method_name, i))
					status = true
				end
			else
				local function_name = line:match(func_pattern)
				if function_name then
					local comment_start, func_start = line:find(comment_pattern), line:find(func_pattern)
					if comment_start then
						if comment_start and func_start and comment_start > func_start then
							table.insert(reduced_lines, string.format("ƒ: %s, line: %d", function_name, i))
							status = true
						end
					else
						table.insert(reduced_lines, string.format("ƒ: %s, line: %d", function_name, i))
						status = true
					end
				end
			end
		end
	end
	if not status then
		table.insert(reduced_lines, "No functions in this file")
	end
	vim.api.nvim_buf_set_lines(buf, 1, -1, false, reduced_lines)
end

return golang
