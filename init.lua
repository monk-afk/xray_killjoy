  --==[[     XRay Killjoy     ]]==--
  --==[[   init.lua   0.0.1   ]]==--
  --==[[  MIT (c) 2024  monk  ]]==--
local S = default.get_translator

  -- Override default ores
minetest.override_item("default:stone_with_diamond", {
  description = S("Stone"),
  tiles = {"default_stone.png"},
  groups = {cracky = 3, not_in_creative_inventory = 1},
  sounds = default.node_sound_stone_defaults(),
  drop = "default:cobble",
})

minetest.override_item("default:stone_with_mese", {
  description = S("Stone"),
  tiles = {"default_stone.png"},
  groups = {cracky = 3, not_in_creative_inventory = 1},
  sounds = default.node_sound_stone_defaults(),
  drop = "default:cobble",
})

minetest.override_item("default:mese", {
  description = S("Stone"),
  tiles = {"default_stone.png"},
  paramtype = "none",
  groups = {cracky = 3, not_in_creative_inventory = 1},
  drop = "default:cobble",
  sounds = default.node_sound_stone_defaults(),
  light_source = 0,
})

minetest.override_item("default:stone_with_gold", {
  description = S("Stone"),
  tiles = {"default_stone.png"},
  groups = {cracky = 3, not_in_creative_inventory = 1},
  drop = "default:cobble",
  sounds = default.node_sound_stone_defaults(),
})


-- Add precious drops to stone
minetest.override_item("default:stone", {
  drop = {
    max_items = math.random(1,3),
    items = {
      {
        items = {"default:diamond"},
        rarity = 500
      },
      {
        items = {"default:mese"},
        rarity = 475
      },
      {
        items = {"default:mese_crystal"},
        rarity = 350
      },
      {
        items = {"default:gold_lump"},
        rarity = 275
      },
      {
        items = {"default:cobble"}
      }
    }
  }
})


  -- Log dropped valuables for the extra paranoid
local function log_precious_drops(digger, drop, pos)
  if minetest.settings:get_bool("log_mods") then
    minetest.log("action", digger.." found "..drop.." at "..pos)
  end
end

  -- Override default node drops
local old_handle_node_drops = minetest.handle_node_drops
function minetest.handle_node_drops(pos, drops, digger)
  if not digger or not digger:is_player() then
    return old_handle_node_drops(pos, drops, digger)
  end

  local inv = digger:get_inventory()
  if inv then
    for _, item in ipairs(drops) do

      if item == "default:mese" then
        if pos.y > -1024 then
          item = "default:cobble"
        else
          log_precious_drops(digger:get_player_name(), item, minetest.pos_to_string(pos))
        end
      end

      if item == "default:diamond" then
        if pos.y > -512 then
          item = "default:cobble"
        else
          log_precious_drops(digger:get_player_name(), item, minetest.pos_to_string(pos))
        end
      end

      if item == "default:mese_crystal"
          or item == "default:gold_lump" then
        if pos.y > -256 then
          item = "default:cobble"
        else
          log_precious_drops(digger:get_player_name(), item, minetest.pos_to_string(pos))
        end
      end

      if inv:room_for_item("main", item) then
        inv:add_item("main", item)
      else
        minetest.add_item(pos, item)
      end
    end
  end
end

--
-- MIT License
-- 
-- Copyright (c) 2024 monk
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.