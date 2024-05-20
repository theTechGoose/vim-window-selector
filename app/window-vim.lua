local utils = require("window-selector.app.window-utils")
local inspect = require("inspect")
local M = {}


function M.create_indicators(windows)
  local indicators = {}
  for i, window_info in ipairs(windows) do
    local indicator = string.lower(string.char(64 + i))
    local result = {label = indicator}
    local merged_result = utils.merge(result, window_info)
    print(inspect(merged_result))
    indicators[#indicators+1] =  merged_result
  end
  return indicators
end

function M.get_all_windows()
  local all_windows = vim.api.nvim_list_wins()
  local windows = {}
  for _, win in ipairs(all_windows) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_name = vim.api.nvim_buf_get_name(buf)
    windows[#windows+1] = { window_number = win, buffer_number = buf, file_in_buffer = buf_name }
  end
  return windows
end

function M.edit_window(window_info, file_name, cleanup_command)
  vim.cmd(cleanup_command)
  vim.api.nvim_set_current_win(window_info.window_number)
  vim.cmd("edit " .. file_name)
end

function M.create_floating_labels(windows, label)
  for _, window_info in ipairs(windows) do
    local current_win = vim.api.nvim_get_current_win()
    -- Create a new buffer
    local buf = vim.api.nvim_create_buf(false, true)

    -- Set lines in the buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { window_info.label })

    -- Calculate position to center the floating window at the bottom
    local width = 3
    local height = 1
    local win_width = vim.api.nvim_win_get_width(window_info.window_number)
    local win_height = vim.api.nvim_win_get_height(window_info.window_number)
    local col = math.floor((win_width - width) / 2)
    local row = win_height - height

    -- Configure the floating window
    local win_config = {
      relative = "win",
      win = window_info.window_number,
      width = width,
      height = height,
      col = col,
      row = row,
      style = "minimal",
      border = "single",
      focusable = false,
    }

    -- Open the floating window
    local float_win = vim.api.nvim_open_win(buf, true, win_config)
    vim.api.nvim_win_set_var(window_info.window_number, "split_indicator_float", float_win)

    -- Apply bright red highlighting to the text
    vim.cmd "highlight BrightRed guifg=#FF0000"

    -- Center the text
    vim.api.nvim_buf_add_highlight(buf, -1, "BrightRed", 0, 0, -1)

    -- Center the text by adding padding spaces
    local centered_text = string.rep(" ", math.floor((width - #window_info.label) / 2)) .. string.upper(window_info.label)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { centered_text })

    vim.api.nvim_set_current_win(current_win)
  end

  return windows
end

function M.clear_floating_labels(windows)
  for _, window_info in ipairs(windows) do
    local ok, float_win = pcall(vim.api.nvim_win_get_var, window_info.window_number, "split_indicator_float")
    if ok then
      pcall(vim.api.nvim_win_close, float_win, true)
    end
  end
end


function M.find_keymap(key)
  local current_mapping = vim.api.nvim_get_keymap "n"
  for _, map in ipairs(current_mapping) do
      if map.lhs == key and map.rhs ~= '' and map.rhs ~= nil then
        return { previous = map.rhs, key = key }
      end
  end
end

function M.nop_mapping(key)
  local mapping = M.find_keymap(key)
  vim.api.nvim_set_keymap("n", key, "<Nop>", { noremap = true })
  if not mapping then
    return { previous = "default", key = key}
  end
  return mapping
end

function M.set_keymap(window_info, factory)
  local map = M.find_keymap(window_info.label)
  local callback = factory(window_info)
  vim.api.nvim_set_keymap("n", window_info.label, '', {
    callback = callback,
    noremap = true,
    silent = true,
  })
  return map
end

function M.restore_keymaps(_toRestore)
  local toRestore = utils.remove_duplicates(_toRestore)
  for _, map in ipairs(toRestore) do
    if(map.previous == "default" or map.previous == nil) then
      pcall(function()
        print('restoring default: ', map.key)
      vim.api.nvim_del_keymap("n", map.key)
      end)
    else
      vim.api.nvim_set_keymap("n", map.key, map.previous, { noremap = true })
    end
  end
end

return M
