local Category = {}
Category.__index = Category

function Category.new(name)
  local obj = {}

  setmetatable(obj, Category)

  if not name then
    error("Name should be set for Category")
  end

  obj.name = name
  obj.children = {}

  return obj
end

function Category:register_children(children)
  if self.children[children.name] ~= nil then
    return self.children[children.name]
  end

  self.children[children.name] = children

  return children
end

return Category
