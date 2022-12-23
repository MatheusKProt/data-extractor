local model = require('model/registry')

local category_game = model.category('game')
local category_item_production_input = model.category('item_production_input')
local category_item_production_output = model.category('item_production_output')
local category_fluid_production_input = model.category('fluid_production_input')
local category_fluid_production_output = model.category('fluid_production_output')
local category_kill_count_input = model.category('kill_count_input')
local category_kill_count_output = model.category('kill_count_output')
local category_entity_build_count_input = model.category('entity_build_count_input')
local category_entity_build_count_output = model.category('entity_build_count_output')

local game_tick = category_game:register_children(model.value("tick"))
local game_connected_players = category_game:register_children(model.value("connected_players"))

local function register_events()
  script.on_event(defines.events.on_tick, function(event)
    if event.tick % settings.startup["data-extract-tick"].value == 0 then
      local connected_players = 0

      for _ in pairs(game.connected_players) do
        connected_players = connected_players + 1
      end

      game_tick:set(game.tick)
      game_connected_players:set(connected_players)

      for _, player in pairs(game.players) do
        local stats = {
          { player.force.item_production_statistics, category_item_production_input, category_item_production_output },
          { player.force.fluid_production_statistics, category_fluid_production_input, category_fluid_production_output },
          { player.force.kill_count_statistics, category_kill_count_input, category_kill_count_output },
          { player.force.entity_build_count_statistics, category_entity_build_count_input,
            category_entity_build_count_output },
        }

        for _, stat in pairs(stats) do
          for name, n in pairs(stat[1].input_counts) do
            local value = stat[2]:register_children(model.value(name))
            value:set(n)
          end

          for name, n in pairs(stat[1].output_counts) do
            local value = stat[3]:register_children(model.value(name))
            value:set(n)
          end
        end

        game.write_file("test/game.prom", model:collect(), false)
      end
    end
  end)
end

script.on_init(function()
  register_events()
end)

script.on_load(function()
  register_events()
end)
