local Value = {}
Value.__index = Value

function Value.new(name)
  local obj = {}

  setmetatable(obj, Value)

  if not name then
    error("Name should be set for Value")
  end

  obj.name = name
  obj.value = 0

  return obj
end

function Value:set(num)
  num = num or 0
  self.value = num
end

return Value
