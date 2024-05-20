local utils = require('window-selector.app.window-utils')
local M = {}

function M.get_nop_maps(used_labels, _all_labels)
  local all_labels = utils.string_to_table(_all_labels)
  return utils.filter(all_labels, function(_, v, _)
    return not utils.contains(used_labels, v)
  end)
end

return M
