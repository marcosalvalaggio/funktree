local api = vim.api
local buf, win
local root_lines = {}
local root_win
local file_extension
local golang = require("golang")
local pylang = require("pylang")
local lualang = require("lualang")
local clang = require("clang")

local function center(str)
    local width = api.nvim_win_get_width(0)
    local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
    return string.rep(' ', shift) .. str
end


local function open_window()
    -- Operations on original buffer
    local current_file = vim.fn.expand("%:t")
    local dot_position = current_file:find("%.[^%.]*$")
    file_extension = current_file:sub(dot_position + 1)
    root_win = vim.api.nvim_get_current_win()
    local root_buf = api.nvim_get_current_buf()
    root_lines = api.nvim_buf_get_lines(root_buf, 0, -1, false)
    -- Create the FT buffer 
    buf = vim.api.nvim_create_buf(false, true)
    local border_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'filetype', 'funktree')
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")
    local win_height = math.ceil(height * 0.6 - 4)
    local win_width = math.ceil(width * 0.6)
    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2)
    -- Graph buffer operations
    local border_opts = {
    style = "minimal",
    relative = "editor",
    width = win_width + 2,
    height = win_height + 2,
    row = row - 1,
    col = col - 1
    }
    local opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col
    }
    local border_lines = { '╔' .. string.rep('═', win_width) .. '╗' }
    local middle_line = '║' .. string.rep(' ', win_width) .. '║'
    for i=1, win_height do
        table.insert(border_lines, middle_line)
    end
    table.insert(border_lines, '╚' .. string.rep('═', win_width) .. '╝')
    vim.api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)
    local border_win = vim.api.nvim_open_win(border_buf, true, border_opts)
    win = api.nvim_open_win(buf, true, opts)
    api.nvim_command('au BufWipeout <buffer> exe "silent bwipeout! "'..border_buf)
    vim.api.nvim_win_set_option(win, 'cursorline', true)
    api.nvim_buf_set_lines(buf, 0, -1, false, { center('FunkTree'), '', ''})

end


local function close_window()
    api.nvim_win_close(win, true)
end


local function update_view(root_lines)
    print(file_extension)
    if file_extension == "py" then
        pylang(root_lines, buf)
    elseif file_extension == "lua" then
        lualang(root_lines, buf)
    -- elseif file_extension == "go" then
        -- golang(root_lines)
        -- golang(root_lines, buf)
    -- elseif file_extension == "c" or file_extension == "h" or file_extension == "cpp" then
        -- clang(root_lines, buf)
    end
end


local function go_to()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local cursor_line = cursor[1] - 1  -- Convert to 0-based index
    local line_text = vim.api.nvim_buf_get_lines(buf, cursor_line, cursor_line + 1, false)[1]
    local line_number = tonumber(string.match(line_text, "line: (%d+)"))
    print(line_number)
    if line_number then
        vim.api.nvim_win_set_cursor(root_win, {line_number, 0})
        close_window()
    end
end


local function set_mappings()
    local mappings = {
        q = 'close_window()',
        ['<cr>'] = 'go_to()'
    }

    for k,v in pairs(mappings) do
        api.nvim_buf_set_keymap(buf, 'n', k, ':lua require"funktree".'..v..'<cr>', {
            nowait = true, noremap = true, silent = true
        })
    end
end


local function funktree()
    open_window()
    update_view(root_lines)
    set_mappings()
    api.nvim_win_set_cursor(win, {2,0})
end


return {
    funktree = funktree,
    update_view = update_view,
    close_window = close_window,
    go_to = go_to
}


