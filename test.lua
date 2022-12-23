local model = require('model/registry')

local category_a = model.category('category_a')
local category_b = model.category('category_b')

local value_a = category_a:register_children(model.value("value_a"))
local value_b = category_a:register_children(model.value("value_b"))
local value_c = category_b:register_children(model.value("value_c"))

value_a:set(1)
value_b:set(2)
value_c:set(3)

print(model:collect())
