local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local theme = require("telescope.themes")
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local lualang = require("lualang")

local api = vim.api
local root_win

local function get_lines()
  local current_file = vim.fn.expand("%:t")
  local dot_position = current_file:find("%.[^%.]*$")
  local file_extension = dot_position and current_file:sub(dot_position + 1) or ""
  local root_lines = {}
  root_win = vim.api.nvim_get_current_win()

  if file_extension == "" then
    vim.api.nvim_err_writeln("No file extension found.")
    return nil, nil
  end

  local root_buf = api.nvim_get_current_buf()
  root_lines = api.nvim_buf_get_lines(root_buf, 0, -1, false)

  return root_lines, file_extension
end

local function extract_function_names(lines, file_extension)
  if file_extension == "lua" then
    local rows = lualang(lines)
    return rows
  else
    vim.api.nvim_err_writeln("Unsupported file extension: " .. file_extension)
    return {}
  end
end

local functest = function(opts)
  local root_lines, file_extension = get_lines()
  if not root_lines or not file_extension then
    return
  end

  local rows = extract_function_names(root_lines, file_extension)
  opts = theme.get_dropdown{}
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "FunkTree",
    finder = finders.new_table {
      results = rows
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        -- print(vim.inspect(selection))
        -- vim.api.nvim_put({ selection[1] }, "", false, true)
        local line_number = tonumber(string.match(selection[1], "line: (%d+)"))
        -- vim.api.nvim_put({tostring(line_number)}, "", false, true)
        vim.api.nvim_win_set_cursor(root_win, { line_number, 0 })
      end)
      return true
    end,
  }):find()
end

return {
  funktree = functest,
}

