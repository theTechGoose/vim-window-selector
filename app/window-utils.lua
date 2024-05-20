local inspect = require('inspect')
local M = {}

function M.write_file(fileName, data)
    local f = io.open(fileName, "w")
    if not f then return end
    f:write(data)
    f:close()
end

function M.string_to_table(str)
    local tbl = {}
    for i = 1, #str do
        local char = str:sub(i, i)
        tbl[#tbl + 1] = char
    end
    return tbl
end

function M.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function M.remove_duplicates(t)
    local seen = {}
    local unique_table = {}

    for _, value in ipairs(t) do
        if not seen[value.key] or (seen[value.key].previous == 'default' and value.previous ~= 'default') then
            unique_table[#unique_table + 1] = value
            seen[value.key] = value
        end
    end

    return unique_table
end

function M.merge(t1, t2)
    local merged_table = {}

    -- Add elements from the first table
    for k, v in pairs(t1) do
        merged_table[k] = v
    end

    -- Add elements from the second table
    for k, v in pairs(t2) do
        if type(k) == "number" then
          merged_table[#merged_table + 1] = v
        else
            merged_table[k] = v
        end
    end

    return merged_table
end

function M.filter(table, callback)
  local output = {}
  local itt = 1

  for k, v in pairs(table) do
    local result = callback(k, v, itt)
    itt = itt + 1
    if result then
      if type(k) == 'number' then
        output[#output + 1] = v
      else
        output[k] = v
      end
    end
  end

  return output
end

function M.map(table, callback)
  local output = {}
  for k, v in pairs(table) do
    output[k] = callback(k, v)
  end
  return output
end

return M
