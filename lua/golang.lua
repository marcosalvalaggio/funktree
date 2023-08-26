
local function golang(root_lines, buf)
    local func_pattern = "func%s+([A-Za-z][A-Za-z0-9]*)"
    local method_pattern = "func%s*%([^)]*%)%s+([A-Za-z][A-Za-z0-9]*)%s*%(%s*%)"
    local struct_pattern = "type%s+([A-Za-z][A-Za-z0-9]*)%s+struct"
    local reduced_lines = {}
    local status = false
    for i, line in ipairs(root_lines) do
        local struct_name = line:match(struct_pattern)
        if struct_name then
            table.insert(reduced_lines, string.format("struct: %s, line: %d", struct_name, i))
            status = true
        else
            local method_name = line:match(method_pattern)
            if method_name then
                table.insert(reduced_lines, string.format("m: %s, line: %d", method_name, i))
                status = true
            else
                local function_name = line:match(func_pattern)
                if function_name then
                    table.insert(reduced_lines, string.format("ƒ: %s, line: %d", function_name, i))
                    status = true
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
