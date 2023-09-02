
local function clang(root_lines, buf)
    local func_pattern = "([A-Za-z_][A-Za-z0-9_]*%s*%*?%*?%s+[A-Za-z_][A-Za-z0-9_]*)%s*%("
    local method_pattern = "    ([A-Za-z_][A-Za-z0-9_]*%s*%*?%*?%s+[A-Za-z_][A-Za-z0-9_]*)%s*%("
    local struct_pattern = "struct%s+([A-Za-z_][A-Za-z0-9_]*)"
    local enum_pattern = "enum%s+([A-Za-z_][A-Za-z0-9_]*)"
    local class_pattern = "class%s+([A-Za-z_][A-Za-z0-9_]*)"
    local typedef_name_pattern = "}%s*([A-Z_][a-z0-9_]*)%s*;"
    local typedef_struct_position_pattern = "typedef struct"
    local typedef_enum_position_pattern = "typedef enum"
    local comment_pattern = "//"
    local typedef_struct_position = nil
    local typedef_enum_position = nil
    local typedef_ongoing = false
    local reduced_lines = {}
    local status = false
    for i, line in ipairs(root_lines) do
        local struct_name = line:match(struct_pattern)
        local enum_name = line:match(enum_pattern)
        local class_name = line:match(class_pattern)
        local typedef_name = line:match(typedef_name_pattern)
        local typedef_struct_position_match = line:match(typedef_struct_position_pattern)
        local typedef_enum_position_match = line:match(typedef_enum_position_pattern)

        if typedef_ongoing then
            if typedef_name then
                typedef_ongoing = false
                if typedef_struct_position then
                    table.insert(reduced_lines, string.format("struct: %s, line: %d", typedef_name, typedef_struct_position))
                    status = true
                elseif typedef_enum_position then
                    table.insert(reduced_lines, string.format("enum: %s, line: %d", typedef_name, typedef_enum_position))
                    status = true
                end
            end
        elseif typedef_struct_position_match then
           typedef_struct_position = i
           typedef_enum_position = nil
           typedef_ongoing = true
        elseif typedef_enum_position_match then
            typedef_enum_position = i
            typedef_struct_position = nil
            typedef_ongoing = true
        elseif struct_name then
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
        elseif enum_name then
            local comment_start, enum_start = line:find(comment_pattern), line:find(enum_pattern)
            if comment_start then
                if comment_start and enum_start and comment_start > enum_start then
                    table.insert(reduced_lines, string.format("enum: %s, line: %d", enum_name, i))
                    status = true
                end
            else
                table.insert(reduced_lines, string.format("enum: %s, line: %d", enum_name, i))
                status = true
            end
        elseif class_name then
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
            if method_name and method_name ~= "struct" and method_name ~= "enum" and string.sub(method_name, 1, 3) ~= "new" then
                local comment_start, method_start = line:find(comment_pattern), line:find(method_pattern)
                if comment_start then
                    if comment_start and method_start and comment_start > method_start then
                        table.insert(reduced_lines, string.format("-->m: %s, line: %d", method_name, i))
                        status = true
                    end
                else
                    table.insert(reduced_lines, string.format("-->m: %s, line: %d", method_name, i))
                    status = true
                end
            else
                local function_name = line:match(func_pattern)
                if function_name and function_name ~= "struct" and function_name ~= "enum" and string.sub(function_name, 1, 3) ~= "new" then
                    print(string.sub(function_name, 1, 6))
                    local comment_start, func_start = line:find(comment_pattern), line:find(func_pattern)
                    if comment_start then
                        if comment_start and func_start and comment_start > func_start then
                            if string.sub(function_name, 1, 6) == "define" then
                                table.insert(reduced_lines, string.format("define: %s, line: %d", function_name, i))
                                status = true
                            else
                                table.insert(reduced_lines, string.format("ƒ: %s, line: %d", function_name, i))
                                status = true
                            end
                        end
                    else
                        if string.sub(function_name, 1, 6) == "define" then
                            table.insert(reduced_lines, string.format("define: %s, line: %d", function_name, i))
                            status = true
                        else
                            table.insert(reduced_lines, string.format("ƒ: %s, line: %d", function_name, i))
                            status = true
                        end
                    end
                end
            end
       end
    end
    if not status then
        table.insert(reduced_lines, "No functions or structs in this file")
    end
    vim.api.nvim_buf_set_lines(buf, 1, -1, false, reduced_lines)
end

return clang
