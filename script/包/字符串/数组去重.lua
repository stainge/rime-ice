
function 数组去重复(数组)
  local exist = {}
  --把相同的元素覆盖掉
  for v, k in pairs(数组) do
    exist[k] = true
  end
  --重新排序表
  local newTable = {}
  for v, k in pairs(exist) do
    table.insert(newTable, v)
  end
  return newTable
end