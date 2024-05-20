local vim_helpers = require('window-selector.app.window-vim')
local utils = require('window-selector.app.window-utils')
local mappings = require('window-selector.app.window-maps')
local constants = require('window-selector.app.window-constants')
local inspect = require('inspect')

local function main(_file, cleanup_command)
  local file = _file[1]
  local windows = vim_helpers.get_all_windows()

  windows = utils.filter(windows, function(_, v, _)
    local file_name = v.file_in_buffer
    local condition = not string.find(file_name, "nnn")
    return condition
  end)

if #windows == 1 then
  vim_helpers.edit_window(windows[1], file, cleanup_command)
else
  local indicators = vim_helpers.create_indicators(windows)
  vim_helpers.create_floating_labels(indicators, file)


  local used_labels = utils.map(indicators, function(_, v, _)
    return v.label
  end)

  local to_restore = {}

  local function factory(selected)
    return function()
      print(selected, file, cleanup_command)
      vim_helpers.edit_window(selected, file, cleanup_command)
      vim_helpers.clear_floating_labels(indicators)
      vim_helpers.restore_keymaps(to_restore)
    end
  end

  for _, indi in ipairs(indicators) do
    local map_to_restore = vim_helpers.set_keymap(indi, factory)
    to_restore[#to_restore + 1] = map_to_restore
  end

  local nop_maps = mappings.get_nop_maps(used_labels, constants.all_keys)



  for _, key in ipairs(nop_maps) do
    local map_to_restore = vim_helpers.nop_mapping(key)
    to_restore[#to_restore + 1] = map_to_restore
  end

end
end

return function(cleanup_command)
  return function(file)
    main(file, cleanup_command)
  end
end
