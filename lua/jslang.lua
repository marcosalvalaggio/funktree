local function jslang(root_lines)
	local func_pattern = "function%s+([%w_]+)%s*%([^)]*"
	local comment_pattern = "//"
	local reduced_lines = {}
	local status = false
	for i, line in ipairs(root_lines) do
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
	if not status then
    return {}
	end
  return reduced_lines
end

return jslang
