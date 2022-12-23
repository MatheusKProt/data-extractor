local Category = require('model/category')
local Value = require('model/value')
local JSON = require('json')

local REGISTRY = nil

local Registry = {}
Registry.__index = Registry

function Registry.new()
  local obj = {}

  setmetatable(obj, Registry)

  obj.collectors = {}
  return obj
end

function Registry:register(collector)
  if self.collectors[collector.name] ~= nil then
    return self.collectors[collector.name]
  end

  self.collectors[collector.name] = collector

  return collector
end

function Registry:collect()
  local obj = {}

  for _, collector in pairs(self.collectors) do
    local children_array = {}
    for _, children in pairs(collector.children) do
      table.insert(children_array, children)
    end
    obj[collector.name] = children_array
  end

  return JSON.encode(obj)
end

local function get_registry()
  if not REGISTRY then
    REGISTRY = Registry.new()
  end

  return REGISTRY
end

local function register(collector)
  local registry = get_registry()

  registry:register(collector)

  return collector
end

local function collect()
  local registry = get_registry()

  return registry:collect()
end

local function category(name)
  return register(Category.new(name))
end

local function value(name)
  return Value.new(name)
end

return {
  collect = collect,
  category = category,
  value = value,
}
