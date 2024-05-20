local util = require('window-utils')
local inspect = require 'inspect'


local test_data = { {
    buffer_number = 3,
    file_in_buffer = "term://~/.config/nvim/lua/window-selector//7490:nnn -o -F1   '/Users/goose/.config/nvim/lua/window-selector/app'",
    window_number = 1002
  }, {
    buffer_number = 1,
    file_in_buffer = "/Users/goose/.config/nvim/lua/window-selector/app/window-utils.lua",
    window_number = 1000
  } }


it('should filter some elements', function() 
  local test_table = {'a', 'b', 'c', 'd', 'e'}
  local output = util.filter(test_data, function(key, value, idx) 
    local file_name = value.file_in_buffer
    local condition = not string.find(file_name, "nnn")
    return condition
  end)
  print(inspect(output))
end)
