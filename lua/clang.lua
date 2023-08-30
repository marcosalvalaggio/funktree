
local function clang(root_lines, buf)
    local func_pattern = "^[A-Za-z_][A-Za-z0-9_]*%s*[*]*%s+([A-Za-z_][A-Za-z0-9_]*)"
    local struct_pattern = "struct%s+([A-Za-z_][A-Za-z0-9_]*)"
    local enum_pattern = "enum%s+([A-Za-z_][A-Za-z0-9_]*)"
    local class_pattern = "class%s+([A-Za-z_][A-Za-z0-9_]*)"
    local typedef_name_pattern = "}%s*([A-Z_][a-z0-9_]*)%s*;"
    local typedef_struct_position_pattern = "typedef struct"
    local typedef_enum_position_pattern = "typedef enum"
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
            table.insert(reduced_lines, string.format("struct: %s, line: %d", struct_name, i))
            status = true
        elseif enum_name then
            table.insert(reduced_lines, string.format("enum: %s, line: %d", enum_name, i))
            status = true
        elseif class_name then
            table.insert(reduced_lines, string.format("class: %s, line: %d", class_name, i))
            status = true
        else
            local function_name = line:match(func_pattern)
            if function_name and function_name ~= "struct" and function_name ~= "enum" then
                table.insert(reduced_lines, string.format("ƒ: %s, line: %d", function_name, i))
                status = true
            end
        end
    end
    if not status then
        table.insert(reduced_lines, "No functions or structs in this file")
    end
    vim.api.nvim_buf_set_lines(buf, 1, -1, false, reduced_lines)
end

return clang
