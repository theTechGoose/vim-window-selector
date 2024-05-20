--local utils = require('window-utils')
local inspect = require 'inspect'

it('should work', function()
  local table = {a = 'a', b ='b', c = {d = 'e'}}
  print('heller')
  print(inspect(table))





  --print('hello world')

  -- utils.write_file('busted.txt', 'busted')

end)
