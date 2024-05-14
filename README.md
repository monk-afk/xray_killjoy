XRay Killjoy
------------
Stop x-ray hacks and surface miners from targeting valuable resources.

<sup>Copyright (c) 2024 monk, MIT License</sup>
___

This mod makes it impossible for modified clients using XRay to target ores embedded in stone.

It also stops "surface mining", and forces miners to actually dig for valued resources.

It changes the ore texture to stone and will drop only cobble. Real stone will drop the ores randomly.

The only way to find diamonds, gold, and mese is by digging stone below the minimum depth.

How it works
------------
Step 1: Override some ore definitions and replace the tile texture with stone, and item drop with cobble.
- The ores will no longer be found visually. The F5 debug will still read the original node name.

```lua
  -- Reverse King Midas
    minetest.override_item("default:stone_with_gold", {
      description = S("Stone"),
      tiles = {"default_stone.png"},
      groups = {cracky = 3, not_in_creative_inventory = 1},
      drop = "default:cobble",
      sounds = default.node_sound_stone_defaults(),
    })
```

Step 2: Add drops to the default stone definition. In this release we add: gold, diamonds, mese and mese block.
- As a grind bonus, the amound of items dropped is randomized between 1 and 3.
- Note, the rarity values in this mod are arbitrary and may not reflect the rarity of mapgen ores.

```lua
    minetest.override_item("default:stone", {
      drop = {
        max_items = math.random(1,3), -- make it worth the grind
        items = {
          {items = {"default:gold_lump"}, rarity = 275}, -- Drop chance is 1 in 500
          {items = {"default:cobble"}} -- Stone is dropped regardless
        }}})
```

Step 3: Redefine minetest.handle_node_drops so we can set the minimum depth of each item drops.

```lua
    function minetest.handle_node_drops(pos, drops, digger)
        --[...]
        for _, item in ipairs(drops) do
          if item == "default:gold_lump" then
            if pos.y > -256 then  -- Minimum depth is below -256
              item = "default:cobble"  -- drop cobble if we're above the minimum
```

That's it.