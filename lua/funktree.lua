-- aggiungere update_view(): trova tutte le funzioni e le classi
-- aggiungere go_to_object(): sposta il cursore all'inizio della funzione
local api = vim.api
local buf, win
local position = 0
local root_lines = {}

local function center(str)
    local width = api.nvim_win_get_width(0)
    local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
    return string.rep(' ', shift) .. str
end


local function open_window()
    local root_buf = api.nvim_get_current_buf()
    root_lines = api.nvim_buf_get_lines(root_buf, 0, -1, false)
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
    api.nvim_buf_set_lines(buf, 0, -1, false, { center('Objects Tree but Funk'), '', ''})

end


local function close_window()
    api.nvim_win_close(win, true)
end


local function update_view()
    local pattern = "def"
    local reduced_lines = {}
    for i, line in ipairs(root_lines) do
        local name = line:match(pattern)
        local res = ""
        if name then
            local extract_pattern = "def%s+(%w+)%("
            res = line:match(extract_pattern)
            Txt = string.format("lines: %d, %s", i, res)
        else
            Txt = string.format("no match: %d", i)
        end
        table.insert(reduced_lines, Txt)
    end
    vim.api.nvim_buf_set_lines(buf, 1, -1, false, reduced_lines)
end

-- <cr>: Enter
local function set_mappings()
    local mappings = {
        q = 'close_window()',
        u = 'update_view()'
    }

    for k,v in pairs(mappings) do
        api.nvim_buf_set_keymap(buf, 'n', k, ':lua require"funktree".'..v..'<cr>', {
            nowait = true, noremap = true, silent = true
        })
    end
end


local function funktree()
    position = 0
    open_window()
    update_view()
    set_mappings()
    api.nvim_win_set_cursor(win, {2,0})
end


return {
    funktree = funktree,
    update_view = update_view,
    close_window = close_window
}





