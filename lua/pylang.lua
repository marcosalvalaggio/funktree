
local function pylang(root_lines, buf)
    -- local class_pattern = "class%s+([%u][%w]*)%s*:"
    local class_pattern = "class%s*%(%s*([%a_][%w_]*)%s*%)%s*:"
    local method_pattern = "    def%s+([%w_]+)%s*%([^)]*"
    local func_pattern = "def%s+([%w_]+)%s*%([^)]*"
    local comment_pattern = "#"
    local reduced_lines = {}
    local status = false
    for i, line in ipairs(root_lines) do
        local class_name = line:match(class_pattern)
        if class_name then
            local comment_start, class_start = line:find(comment_pattern), line:find(class_pattern)
            if comment_start then
                if comment_start and class_start and comment_start > class_start then
                    table.insert(reduced_lines, string.format("class: %s, line: %d", class_name, i))
                    status = true
                end
            else
                table.insert(reduced_lines, string.format("class: %s, line: %d", class_name, i))
                status = true
            end
        else
            local method_name = line:match(method_pattern)
            if method_name then
                local comment_start, method_start = line:find(comment_pattern), line:find(method_pattern)
                if comment_start then
                    if comment_start and method_start and comment_start > method_start then
                        table.insert(reduced_lines, string.format("|-->m: %s, line: %d", method_name, i))
                        status = true
                    end
                else
                    table.insert(reduced_lines, string.format("|-->m: %s, line: %d", method_name, i))
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
        table.insert(reduced_lines, "No Funk in this file")
    end
    vim.api.nvim_buf_set_lines(buf, 1, -1, false, reduced_lines)
end

return pylang
