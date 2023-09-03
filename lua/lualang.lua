
local function lualang(root_lines, buf)
    local func_pattern = "function%s+([%w_]+)%s*%([^)]*%)"
    local comment_pattern = "--"
    local reduced_lines = {}
    local status = false
    for i, line in ipairs(root_lines) do
        local func_name = line:match(func_pattern)
        if func_name then
            local comment_start, func_start = line:find(comment_pattern), line:find(func_pattern)
            if comment_start then
                print("log")
                print(i)
            end
            table.insert(reduced_lines, string.format("ƒ: %s, line: %d", func_name, i))
            status = true
        end
    end
    if not status then
        table.insert(reduced_lines, "No functions in this file")
    end
    vim.api.nvim_buf_set_lines(buf, 1, -1, false, reduced_lines)
end

return lualang
