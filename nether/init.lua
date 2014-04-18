-- Nether Mod (based on Nyanland by Jeija, Catapult by XYZ, and Livehouse by neko259)
-- lkjoel (main developer, code, ideas, textures)
-- == CONTRIBUTERS ==
-- jordan4ibanez (code, ideas, textures)
-- Gilli (code, ideas, textures, mainly for the Glowstone)
-- Death Dealer (code, ideas, textures)
-- LolManKuba (ideas, textures)
-- IPushButton2653 (ideas, textures)
-- Menche (textures)
-- sdzen (ideas)
-- godkiller447 (ideas)
-- If I didn't list you, please let me know!

--== EDITABLE OPTIONS ==--

-- Depth of the nether
NETHER_DEPTH = -20000
-- Height of the nether (bottom of the nether is NETHER_DEPTH - NETHER_HEIGHT)
NETHER_HEIGHT = 30
-- Maximum amount of randomness in the map generation
NETHER_RANDOM = 2
-- Frequency of Glowstone on the "roof" of the Nether (higher is less frequent)
GLOWSTONE_FREQ_ROOF = 500
-- Frequency of Glowstone on lava (higher is less frequent)
GLOWSTONE_FREQ_LAVA = 2
-- Frequency of lava (higher is less frequent)
LAVA_FREQ = 100
-- Maximum height of lava
LAVA_HEIGHT = 2
NETHER_TREE_FREQ = 350
NETHER_SHROOM_FREQ = 100
-- Height of nether trees
NETHER_TREESIZE = 2
-- Frequency of apples in a nether tree (higher is less frequent)
NETHER_APPLE_FREQ = 5
-- Frequency of healing apples in a nether tree (higher is less frequent)
NETHER_HEAL_APPLE_FREQ = 10
-- Start position for the Throne of Hades (y is relative to the bottom of the nether)
HADES_THRONE_STARTPOS = {x=0, y=1, z=0}
-- Spawn pos for when the nether hasn't been loaded yet (i.e. no portal in the nether) (y is relative to the bottom of the nether)
NETHER_SPAWNPOS = {x=0, y=5, z=0}
-- Structure of the nether portal (all is relative to the nether portal creator block)
NETHER_PORTAL = {
	-- Floor 1
	{pos={x=0,y=0,z=0}, block="default:obsidian"},
	{pos={x=1,y=0,z=0}, block="default:obsidian"},
	{pos={x=2,y=0,z=0}, block="default:obsidian"},
	{pos={x=3,y=0,z=0}, block="default:obsidian"},
	{pos={x=0,y=0,z=1}, block="default:obsidian"},
	{pos={x=1,y=0,z=1}, block="default:obsidian"},
	{pos={x=2,y=0,z=1}, block="default:obsidian"},
	{pos={x=3,y=0,z=1}, block="default:obsidian"},
	{pos={x=0,y=0,z=-1}, block="default:obsidian"},
	{pos={x=1,y=0,z=-1}, block="default:obsidian"},
	{pos={x=2,y=0,z=-1}, block="default:obsidian"},
	{pos={x=3,y=0,z=-1}, block="default:obsidian"},
	-- Floor 2
	{pos={x=0,y=1,z=0}, block="default:obsidian"},
	{pos={x=1,y=1,z=0}, block="nether:portal"},
	{pos={x=2,y=1,z=0}, block="nether:portal"},
	{pos={x=3,y=1,z=0}, block="default:obsidian"},
	{pos={x=0,y=1,z=1}, block="default:obsidian"},
	{pos={x=3,y=1,z=1}, block="default:obsidian"},
	{pos={x=0,y=1,z=-1}, block="default:obsidian"},
	{pos={x=3,y=1,z=-1}, block="default:obsidian"},
	-- Floor 3
	{pos={x=0,y=2,z=0}, block="default:obsidian"},
	{pos={x=1,y=2,z=0}, block="nether:portal"},
	{pos={x=2,y=2,z=0}, block="nether:portal"},
	{pos={x=3,y=2,z=0}, block="default:obsidian"},
	{pos={x=0,y=2,z=1}, block="default:obsidian"},
	{pos={x=3,y=2,z=1}, block="default:obsidian"},
	{pos={x=0,y=2,z=-1}, block="default:obsidian"},
	{pos={x=3,y=2,z=-1}, block="default:obsidian"},
	-- Floor 4
	{pos={x=0,y=3,z=0}, block="default:obsidian"},
	{pos={x=1,y=3,z=0}, block="nether:portal"},
	{pos={x=2,y=3,z=0}, block="nether:portal"},
	{pos={x=3,y=3,z=0}, block="default:obsidian"},
	{pos={x=0,y=3,z=1}, block="default:obsidian"},
	{pos={x=3,y=3,z=1}, block="default:obsidian"},
	{pos={x=0,y=3,z=-1}, block="default:obsidian"},
	{pos={x=3,y=3,z=-1}, block="default:obsidian"},
	-- Floor 5
	{pos={x=0,y=4,z=0}, block="default:obsidian"},
	{pos={x=1,y=4,z=0}, block="default:obsidian"},
	{pos={x=2,y=4,z=0}, block="default:obsidian"},
	{pos={x=3,y=4,z=0}, block="default:obsidian"},
	{pos={x=0,y=4,z=1}, block="default:obsidian"},
	{pos={x=1,y=4,z=1}, block="default:obsidian"},
	{pos={x=2,y=4,z=1}, block="default:obsidian"},
	{pos={x=3,y=4,z=1}, block="default:obsidian"},
	{pos={x=0,y=4,z=-1}, block="default:obsidian"},
	{pos={x=1,y=4,z=-1}, block="default:obsidian"},
	{pos={x=2,y=4,z=-1}, block="default:obsidian"},
	{pos={x=3,y=4,z=-1}, block="default:obsidian"},
}

--== END OF EDITABLE OPTIONS ==--

local path = minetest.get_modpath("nether")
dofile(path.."/weird_mapgen_noise.lua")

local function dif(z1, z2)
	if z1 < 0
	and z2 < 0 then
		z1,z2 = -z1,-z2
	end
	return math.abs(z1-z2)
end

local function pymg(x1, x2, z1, z2)
	return math.max(dif(x1, x2), dif(z1, z2))
end

local function r_area(manip, width, height, pos)
	local emerged_pos1, emerged_pos2 = manip:read_from_map(
		{x=pos.x-width, y=pos.y, z=pos.z-width},
		{x=pos.x+width, y=pos.y+height, z=pos.z+width}
	)
	return VoxelArea:new({MinEdge=emerged_pos1, MaxEdge=emerged_pos2})
end

local function set_vm_data(manip, nodes, pos, t1, name)
	manip:set_data(nodes)
	manip:write_to_map()
	print(string.format("[nether] "..name.." grew at ("..pos.x.."|"..pos.y.."|"..pos.z..") after ca. %.2fs", os.clock() - t1))
	local t1 = os.clock()
	manip:update_map()
	print(string.format("[nether] map updated after ca. %.2fs", os.clock() - t1))
end

-- Generated variables
NETHER_BOTTOM = (NETHER_DEPTH - NETHER_HEIGHT)
NETHER_ROOF_ABS = (NETHER_DEPTH - NETHER_RANDOM)
--HADES_THRONE_STARTPOS_ABS = {x=HADES_THRONE_STARTPOS.x, y=(NETHER_BOTTOM + HADES_THRONE_STARTPOS.y), z=HADES_THRONE_STARTPOS.z}
LAVA_Y = (NETHER_BOTTOM + LAVA_HEIGHT)
--HADES_THRONE_ABS = {}
--HADES_THRONE_ENDPOS_ABS = {}
--HADES_THRONE_GENERATED = minetest.get_worldpath() .. "/netherhadesthrone.txt"
NETHER_SPAWNPOS_ABS = {x=NETHER_SPAWNPOS.x, y=(NETHER_BOTTOM + NETHER_SPAWNPOS.y), z=NETHER_SPAWNPOS.z}
--[[for i,v in ipairs(HADES_THRONE) do
	v.pos.x = v.pos.x + HADES_THRONE_STARTPOS_ABS.x
	v.pos.y = v.pos.y + HADES_THRONE_STARTPOS_ABS.y
	v.pos.z = v.pos.z + HADES_THRONE_STARTPOS_ABS.z
	HADES_THRONE_ABS[i] = v
end
local htx = 0
local hty = 0
local htz = 0
for i,v in ipairs(HADES_THRONE_ABS) do
	if v.pos.x > htx then
		htx = v.pos.x
	end
	if v.pos.y > hty then
		hty = v.pos.y
	end
	if v.pos.z > htz then
		htz = v.pos.z
	end
end
HADES_THRONE_ENDPOS_ABS = {x=htx, y=hty, z=htz}]]
local nether = {}

-- == General Utility Functions ==

-- Check if file exists
function nether:fileexists(file)
	file = io.open(file, "r")
	if file ~= nil then
		file:close()
		return true
	else
		return false
	end
end

-- Simple "touch" function
function nether:touch(file)
	if nether:fileexists(file) ~= true then
		file = io.open(file, "w")
		if file ~= nil then
			file:write("")
			file:close()
		end
	end
end

-- Print a message
function nether:printm(message)
	print("[Nether] " .. message)
end

-- Print an error message
function nether:printerror(message)
	nether:printm("Error! " .. message)
end

-- == Nether related stuff ==

-- Find if a position is inside the Nether
function nether:inside_nether(pos)
	if pos.y >= NETHER_BOTTOM and pos.y <= NETHER_DEPTH then
		return true
	end
	return false
end

--[[ Nether Lava
minetest.register_node("nether:lava_flowing", {
	description = "Nether Lava (flowing)",
	inventory_image = minetest.inventorycube("default_lava.png"),
	drawtype = "flowingliquid",
	tiles = {"default_lava.png"},
	paramtype = "light",
	light_source = LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	liquidtype = "flowing",
	liquid_alternative_flowing = "nether:lava_flowing",
	liquid_alternative_source = "default:lava_source",
	liquid_viscosity = LAVA_VISC,
	damage_per_second = 4*2,
	post_effect_color = {a=192, r=255, g=64, b=0},
	special_materials = {
		{image="default_lava.png", backface_culling=false},
		{image="default_lava.png", backface_culling=true},
	},
	groups = {lava=3, liquid=2, hot=3},
})

minetest.register_node("nether:lava_source", {
	description = "Nether Lava",
	inventory_image = minetest.inventorycube("default_lava.png"),
	drawtype = "liquid",
	tiles = {"default_lava.png"},
	paramtype = "light",
	light_source = LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	liquidtype = "source",
	liquid_alternative_flowing = "nether:lava_flowing",
	liquid_alternative_source = "default:lava_source",
	liquid_viscosity = LAVA_VISC,
	damage_per_second = 4*2,
	post_effect_color = {a=192, r=255, g=64, b=0},
	special_materials = {
		-- New-style lava source material (mostly unused)
		{image="default_lava.png", backface_culling=false},
	},
	groups = {lava=3, liquid=2, hot=3},
})]]

-- Netherrack
minetest.register_node("nether:netherrack", {
	description = "Netherrack",
	tiles = {"nether_netherrack.png"},
	groups = {cracky=3, oddly_breakable_by_hand=3},
	sounds = default.node_sound_stone_defaults(),
})

-- Netherbrick
minetest.register_node("nether:netherrack_brick", {
	description = "Netherrack Brick",
	tiles = {"nether_netherrack.png^nether_brick_shadow.png"},
	groups = {cracky=3, oddly_breakable_by_hand=3},
	sounds = default.node_sound_stone_defaults(),
})

-- Nether tree
minetest.register_node("nether:blood", {
	description = "Nether Blood",
	tiles = {"nether_blood.png"},
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("nether:blood_top", {
	description = "Nether Blood",
	tiles = {"nether_blood_top.png", "nether_blood.png", "nether_blood.png^nether_blood_side.png"},
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("nether:blood_stem", {
	description = "Nether Blood Stem",
	tiles = {"nether_blood_stem_top.png", "nether_blood_stem_top.png", "nether_blood_stem.png"},
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=1},
	sounds = default.node_sound_wood_defaults(),
})

--[[ Nether leaves
minetest.register_node("nether:leaves", {
	description = "Nether Leaves",
	drawtype = "allfaces_optional",
--	visual_scale = 1.189, --scale^2=sqrt(2)
	tiles = {"nether_leaves.png"},
	paramtype = "light",
	groups = {snappy=3, leafdecay=2},
	sounds = default.node_sound_leaves_defaults(),
})]]

-- Nether apple
minetest.register_node("nether:apple", {
	description = "Nether Apple",
	drawtype = "plantlike",
	tiles = {"nether_apple.png"},
	inventory_image = "nether_apple.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {fleshy=3, dig_immediate=3},
	on_use = minetest.item_eat(-4),
	sounds = default.node_sound_defaults(),
})

-- Nether vine
minetest.register_node("nether:vine", {
	description = "Nether vine",
	walkable = false,
	drop = '',
	sunlight_propagates = true,
	paramtype = "light",
	tiles = { "nether_vine.png" },
	drawtype = "plantlike",
	inventory_image = "nether_vine.png",
	groups = { snappy = 3,flammable=2 },
	sounds = default.node_sound_leaves_defaults(),
	after_dig_node = function(pos)
		local p = {x=pos.x, y=pos.y-1, z=pos.z}
		local vine = "nether:vine"
		while minetest.get_node(p).name == vine do
			minetest.remove_node(p)
			p.y = p.y-1
		end
	end 
})

-- Nether torch
minetest.register_node("nether:torch", {
	description = "Nether Torch",
	drawtype = "torchlike",
	tiles = {"nether_torch_on_floor.png", "nether_torch_on_ceiling.png", "nether_torch.png"},
	inventory_image = "nether_torch_on_floor.png",
	wield_image = "nether_torch_on_floor.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	light_source = LIGHT_MAX - 1,
	selection_box = {
		type = "wallmounted",
		wall_top = {-0.1, 0.5-0.6, -0.1, 0.1, 0.5, 0.1},
		wall_bottom = {-0.1, -0.5, -0.1, 0.1, -0.5+0.6, 0.1},
		wall_side = {-0.5, -0.3, -0.1, -0.5+0.3, 0.3, 0.1},
	},
	groups = {choppy=2, dig_immediate=3},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
})

-- Nether Pearl
minetest.register_craftitem("nether:pearl", {
	description = "Nether Pearl",
	wield_image = "nether_pearl.png",
	inventory_image = "nether_pearl.png",
	visual = "sprite",
	physical = true,
	textures = {"nether_pearl.png"},
})

local c_air = minetest.get_content_id("air")
local c_netherrack = minetest.get_content_id("nether:netherrack")
local c_netherrack_brick = minetest.get_content_id("nether:netherrack_brick")
local c_glowstone = minetest.get_content_id("glow:stone") --https://github.com/Zeg9/minetest-glow
local c_lava = minetest.get_content_id("default:lava_source")
local c_nether_shroom = minetest.get_content_id("riesenpilz:nether_shroom")
local c_nether_vine = minetest.get_content_id("nether:vine")

local function return_nether_ore(glowstone)
	if glowstone
	and pr:next(0,GLOWSTONE_FREQ_ROOF) == 1 then
		return c_glowstone
	end
	return c_netherrack
end

local info = true
local trees_enabled = true
local vine_maxlength = math.floor(NETHER_HEIGHT/4+0.5)
-- Create the Nether
minetest.register_on_generated(function(minp, maxp, seed)
	if not (maxp.y >= NETHER_BOTTOM-100 and minp.y <= NETHER_DEPTH+100) then --avoid big map generation
		return
	end
	local addpos = {}

	if info then
		t1 = os.clock()
		local geninfo = "[nether] generates at: x=["..minp.x.."; "..maxp.x.."]; y=["..minp.y.."; "..maxp.y.."]; z=["..minp.z.."; "..maxp.z.."]"
		print(geninfo)
		minetest.chat_send_all(geninfo)
	end

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}

	pr = PseudoRandom(seed+33)
	local tab,num = {},1
	local num2 = 1

	local perlin1 = minetest.get_perlin(13,3, 0.5, 50)	--Get map specific perlin
	local perlin2 = minetest.get_perlin(133,3, 0.5, 10)
	local perlin3 = minetest.get_perlin(112,3, 0.5, 5)
	local tab2 = nether_weird_noise(minp, pymg, 20, 8)

	for z=minp.z, maxp.z do
		for x=minp.x, maxp.x do

			local r_tree = pr:next(1,NETHER_TREE_FREQ)
			local r_shroom = pr:next(1,NETHER_SHROOM_FREQ)
			local r_glowstone = pr:next(0,GLOWSTONE_FREQ_ROOF)
			local r_vine_length = pr:next(1,vine_maxlength)

			local test = perlin1:get2d({x=x, y=z})+1
			local test2 = perlin2:get2d({x=x, y=z})
			local test3 = math.abs(perlin3:get2d({x=x, y=z}))

			local t = math.floor(test*3+0.5)

			if test2 < 0 then
				h = math.floor(test2*3+0.5)-1
			else
				h = 3+t+pr:next(0,NETHER_RANDOM)
			end

			local generate_vine = false
			if test3 >= 0.72+pr:next(0,NETHER_RANDOM)/10
			and pr:next(0,NETHER_RANDOM) == 1 then
				generate_vine = true
			end

			local bottom = NETHER_BOTTOM+h
			local top = NETHER_DEPTH-pr:next(0,NETHER_RANDOM)+t

			local py_h = tab2[num2].y
			num2 = num2+1

			for y=minp.y, maxp.y, 1 do
				local p_addpos = area:index(x, y, z)
				--if py_h >= maxp.y-4 then
				if y == py_h then
					data[p_addpos] = c_netherrack_brick
					--[[else
						data[p_addpos] = c_air
					end]]
				elseif data[p_addpos] ~= c_air then
					if y <= NETHER_BOTTOM then
						if y <= bottom then
							data[p_addpos] = return_nether_ore(1)
						else
							data[p_addpos] = c_lava
						end
					elseif r_tree == 1
					and y == bottom then
						tab[num] = {x=x, y=y-1, z=z}
						num = num+1
					elseif y <= bottom then
						if pr:next(1,LAVA_FREQ) == 1 then
							data[p_addpos] = c_lava
						else
							data[p_addpos] = return_nether_ore(0)
						end
					elseif r_shroom == 1
					and r_tree ~= 1
					and y == bottom+1 then
						data[p_addpos] = c_nether_shroom
					elseif (y == top and r_glowstone == 1) then
						data[p_addpos] = c_glowstone
					elseif y >= top then
						data[p_addpos] = return_nether_ore(1)
					elseif y <= top-1
					and generate_vine
					and y >= top-r_vine_length then
						data[p_addpos] = c_nether_vine
					else
						data[p_addpos] = c_air
					end
				end
--				d_p_addpos = data[p_addpos]
			end
		end
	end
	vm:set_data(data)
--	vm:set_lighting(12)
	vm:calc_lighting()
	vm:update_liquids()
	vm:write_to_map()
	if trees_enabled then	--Trees:
		for _,v in ipairs(tab) do
			nether:grow_nethertree(v)
		end
	end
	--[[ We don't want the Throne of Hades to get regenerated (especially since it will screw up portals)
	if (minp.x <= HADES_THRONE_STARTPOS_ABS.x)
	and (maxp.x >= HADES_THRONE_STARTPOS_ABS.x)
	and (minp.y <= HADES_THRONE_STARTPOS_ABS.y)
	and (maxp.y >= HADES_THRONE_STARTPOS_ABS.y)
	and (minp.z <= HADES_THRONE_STARTPOS_ABS.z)
	and (maxp.z >= HADES_THRONE_STARTPOS_ABS.z)
	and (nether:fileexists(HADES_THRONE_GENERATED) == false) then
		-- Pass 3: Make way for the Throne of Hades!
		for x=(HADES_THRONE_STARTPOS_ABS.x - 1), (HADES_THRONE_ENDPOS_ABS.x + 1), 1 do
			for z=(HADES_THRONE_STARTPOS_ABS.z - 1), (HADES_THRONE_ENDPOS_ABS.z + 1), 1 do
				-- Notice I did not put a -1 for the beginning. This is because we don't want the throne to float
				for y=HADES_THRONE_STARTPOS_ABS.y, (HADES_THRONE_ENDPOS_ABS.y + 1), 1 do
					addpos = {x=x, y=y, z=z}
					minetest.add_node(addpos, {name="air"})
				end
			end
		end
		-- Pass 4: Throne of Hades
		for i,v in ipairs(HADES_THRONE_ABS) do
			if v.portalblock == true then
				NETHER_PORTALS_FROM_NETHER[table.getn(NETHER_PORTALS_FROM_NETHER)+1] = v.pos
				nether:save_portal_from_nether(v.pos)
				nether:createportal(v.pos)
			else
				minetest.add_node(v.pos, {name=v.block})
			end
		end
		nether:touch(HADES_THRONE_GENERATED)
	end]]
	if info then
		local geninfo = string.format("[nether] done after: %.2fs", os.clock() - t1)
		print(geninfo)
		minetest.chat_send_all(geninfo)
	end
end)

--[[minetest.register_on_generated(function(minp, maxp, seed)
	if minp.y <= 99 then
		return
	end
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}

	local perlin1 = minetest.get_perlin(13,3, 0.5, 50)	--Get map specific perlin
	local perlin2 = minetest.get_perlin(133,3, 0.5, 10)
	for x=minp.x, maxp.x, 1 do
		for z=minp.z, maxp.z, 1 do
			local test = perlin1:get2d({x=x, y=z})+1
			local test2 = perlin2:get2d({x=x, y=z})
--			print(test)
			if test2 < 0 then
				h = 200+math.floor(test2*3+0.5)
			else
				h = 203+math.floor(test*3+0.5)
			end
			for y=minp.y, maxp.y, 1 do
				p_addpos = area:index(x, y, z)
				if y <= h then
					data[p_addpos] = c_netherrack
				elseif y <= 201 then
					data[p_addpos] = c_lava
				end
			end
		end
	end

	vm:set_data(data)
	--vm:set_lighting({day=0, night=0})
	vm:calc_lighting()
	vm:update_liquids()
	vm:write_to_map()
end)]]


-- Return the name of the node below a position
function nether:nodebelow(pos)
	return minetest.get_node({x=pos.x, y=(pos.y-1), z=pos.z}).name
end

-- Check if we can add a "sticky" node (i.e. it has to stick to something else, or else it won't be added)
-- This is largely based on Gilli's code
function nether:can_add_sticky_node(pos)
	local objname
	for x = -1, 1 do
		for y = -1, 1 do
			for z = -1, 1 do
				local p = {x=pos.x+x, y=pos.y+y, z=pos.z+z}
				local n = minetest.get_node(p)
				objname = n.name
				if minetest.registered_nodes[objname].walkable == true then
					return true
				end
			end
		end
	end
	return false
end

-- Add a "sticky" node
function nether:add_sticky_node(pos, opts)
	if nether:can_add_sticky_node(pos) == true then
		minetest.add_node(pos, opts)
		return true
	else
		return false
	end
end


local nether_c_blood = minetest.get_content_id("nether:blood")
local nether_c_blood_top = minetest.get_content_id("nether:blood_top")
local nether_c_blood_stem = minetest.get_content_id("nether:blood_stem")
local nether_c_apple = minetest.get_content_id("default:apple")
local nether_c_nether_apple = minetest.get_content_id("nether:apple")

function nether:grow_nethertree(pos)
	local t1 = os.clock()
	local height = 6
	local manip = minetest.get_voxel_manip()
	local area = r_area(manip, 2, height, pos)
	local nodes = manip:get_data()

	for i = 0, height-1 do
		nodes[area:index(pos.x, pos.y+i, pos.z)] = nether_c_blood_stem
	end

	for i = -1,1 do
		for j = -1,1 do
			nodes[area:index(pos.x+i, pos.y+height, pos.z+j)] = nether_c_blood_top
		end
	end

	for k = -1, 1, 2 do
		for l = -2+1, 2 do
			local p1 = {pos.x+2*k, pos.y+height, pos.z-l*k}
			local p2 = {pos.x+l*k, pos.y+height, pos.z+2*k}
			local udat = nether_c_blood_top
			if math.random(2) == 1 then
				nodes[area:index(p1[1], p1[2], p1[3])] = nether_c_blood_top
				nodes[area:index(p2[1], p2[2], p2[3])] = nether_c_blood_top
				udat = nether_c_blood
			end
			nodes[area:index(p1[1], p1[2]-1, p1[3])] = udat
			nodes[area:index(p2[1], p2[2]-1, p2[3])] = udat
		end
		for l = 0, 1 do
			for _,p in ipairs({
				{pos.x+k, pos.y+height-1, pos.z-l*k},
				{pos.x+l*k, pos.y+height-1, pos.z+k},
			}) do
				if math.random(2) == 1 then
					nodes[area:index(p[1], p[2], p[3])] = nether_c_nether_apple
				elseif math.random(10) == 1 then
					nodes[area:index(p[1], p[2], p[3])] = nether_c_apple
				end
			end
		end
	end
	set_vm_data(manip, nodes, pos, t1, "blood")
end
--[[ Create a nether tree
function nether:grow_nethertree(pos)
	--TRUNK
	pos.y=pos.y+1
	local trunkpos={x=pos.x, z=pos.z}
	for y=pos.y, pos.y+4+math.random(2) do
		trunkpos.y=y
		minetest.add_node(trunkpos, {name="nether:tree"})
	end
	--LEAVES
	local leafpos={}
	for x=(trunkpos.x-NETHER_TREESIZE), (trunkpos.x+NETHER_TREESIZE), 1 do
		for y=(trunkpos.y-NETHER_TREESIZE), (trunkpos.y+NETHER_TREESIZE), 1 do
			for z=(trunkpos.z-NETHER_TREESIZE), (trunkpos.z+NETHER_TREESIZE), 1 do
				if (x-trunkpos.x)*(x-trunkpos.x)
				+(y-trunkpos.y)*(y-trunkpos.y)
				+(z-trunkpos.z)*(z-trunkpos.z)
				<= NETHER_TREESIZE*NETHER_TREESIZE + NETHER_TREESIZE then
					leafpos={x=x, y=y, z=z}
					if minetest.get_node(leafpos).name=="air" then
						if math.random(NETHER_APPLE_FREQ) == 1 then
							if math.random(NETHER_HEAL_APPLE_FREQ) == 1 then
								minetest.add_node(leafpos, {name="default:apple"})
							else
								minetest.add_node(leafpos, {name="nether:apple"})
							end
						else
							minetest.add_node(leafpos, {name="nether:leaves"})
						end				
					end				
				end
			end
		end
	end
end]]

-- == PORTAL RELATED STUFF ==
NETHER_PORTALS_TO_NETHER = {}
NETHER_PORTALS_FROM_NETHER = {}
NETHER_PORTALS_TO_NETHER_FILE = minetest.get_worldpath() .. "/portalstonether.txt"
NETHER_PORTALS_FROM_NETHER_FILE = minetest.get_worldpath() .. "/portalsfromnether.txt"

-- Count the number of times a position appears in a table
function table_count(tt, item)
	local count
	count = 0
	for ii,xx in pairs(tt) do
		if (item.x == xx.x) and (item.y == xx.y) and (item.z == xx.z) then
			count = count + 1
		end
	end
	return count
end


-- Remove duplicate positions from table
function table_unique(tt)
	local newtable
	newtable = {}
	for ii,xx in ipairs(tt) do
		if(table_count(newtable, xx) == 0) then
			newtable[#newtable+1] = xx
		end
	end
	return newtable
end

-- Copied from neko259 with a few minor edits from lkjoel
function split(pString, pPattern)
	local Table = {}
	local fpat = "(.-)" .. pPattern
	local last_end = 1
	local s, e, cap = pString:find(fpat, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(Table,cap)
		end
		last_end = e+1
		s, e, cap = pString:find(fpat, last_end)
	end
	if last_end <= #pString then
		cap = pString:sub(last_end)
		table.insert(Table, cap)
	end
	return Table
end

-- Save a portal to nether
function nether:save_portal_to_nether(pos)
	local file = io.open(NETHER_PORTALS_TO_NETHER_FILE, "a")
	if file ~= nil then
		file:write("x" .. pos.x .. "\ny" .. pos.y .. "\nz" .. pos.z .. "\np", "\n")
		file:close()
	else
		nether:printerror("Cannot write portal to file!")
	end
end

-- Save all nether portals
function nether:save_portals_to_nether()
	local array2 = NETHER_PORTALS_TO_NETHER
	NETHER_PORTALS_TO_NETHER = table_unique(array2)
	file = io.open(NETHER_PORTALS_TO_NETHER_FILE, "w")
	if file ~= nil then
		file:write("")
		file:close()
		for i,v in ipairs(NETHER_PORTALS_TO_NETHER) do
			nether:save_portal_to_nether(v)
		end
	else
		nether:printerror("Cannot create portal file!")
	end
end

-- Save a portal from nether
function nether:save_portal_from_nether(pos)
	local file = io.open(NETHER_PORTALS_FROM_NETHER_FILE, "a")
	if file ~= nil then
		file:write("x" .. pos.x .. "\ny" .. pos.y .. "\nz" .. pos.z .. "\np", "\n")
		file:close()
	else
		nether:printerror("Cannot write portal to file!")
	end
end

-- Save all portals from nether
function nether:save_portals_from_nether()
	local array2 = NETHER_PORTALS_FROM_NETHER
	NETHER_PORTALS_FROM_NETHER = table_unique(array2)
	file = io.open(NETHER_PORTALS_FROM_NETHER_FILE, "w")
	if file ~= nil then
		file:write("")
		file:close()
		for i,v in ipairs(NETHER_PORTALS_FROM_NETHER) do
			nether:save_portal_from_nether(v)
		end
	else
		nether:printerror("Cannot create portal file!")
	end
end

-- Read portals to nether
function nether:read_portals_to_nether()
	local array = {}
	local array2 = {}
	local file = io.open(NETHER_PORTALS_TO_NETHER_FILE, "r")
	if file ~= nil then
		for line in io.lines(NETHER_PORTALS_TO_NETHER_FILE) do
			if not (line == "" or line == nil) then
				if line:sub(1, 1) == "p" then
					array2[table.getn(array2)+1] = array
				elseif line:sub(1, 1) == "x" then
					array.x = tonumber(split(line, "x")[1])
				elseif line:sub(1, 1) == "y" then
					array.y = tonumber(split(line, "y")[1])
				elseif line:sub(1, 1) == "z" then
					array.z = tonumber(split(line, "z")[1])
				end
			end
		end
	else
		file = io.open(NETHER_PORTALS_TO_NETHER_FILE, "w")
		if file ~= nil then
			file:write("")
			file:close()
		else
			nether:printerror("Cannot create portal file!")
		end
	end
	NETHER_PORTALS_TO_NETHER = table_unique(array2)
end

-- Read portals from nether
function nether:read_portals_from_nether()
	local array = {}
	local array2 = {}
	local file = io.open(NETHER_PORTALS_FROM_NETHER_FILE, "r")
	if file ~= nil then
		for line in io.lines(NETHER_PORTALS_FROM_NETHER_FILE) do
			if not (line == "" or line == nil) then
				if line:sub(1, 1) == "p" then
					array2[table.getn(array2)+1] = array
				elseif line:sub(1, 1) == "x" then
					array.x = tonumber(split(line, "x")[1])
				elseif line:sub(1, 1) == "y" then
					array.y = tonumber(split(line, "y")[1])
				elseif line:sub(1, 1) == "z" then
					array.z = tonumber(split(line, "z")[1])
				end
			end
		end
	else
		file = io.open(NETHER_PORTALS_FROM_NETHER_FILE, "w")
		if file ~= nil then
			file:write("")
			file:close()
		else
			nether:printerror("Cannot create portal file!")
		end
	end
	NETHER_PORTALS_FROM_NETHER = table_unique(array2)
end

nether:read_portals_to_nether()
nether:read_portals_from_nether()

-- Teleport the player
function nether:teleport_player(from_nether, player)
	local randomportal = 1
	local coin = math.floor(math.random(0, 1))
	if coin == 0 then
		coin = -1
	else
		coin = 1
	end
	local coin2 = math.floor(math.random(1, 2))
	local num = 1
	local forgetit = false
	if from_nether == true then
		num = table.getn(NETHER_PORTALS_TO_NETHER)
		if num == 1 then
			randomportal = 1
		elseif num < 1 then
			forgetit = true
			teleportpos = NETHER_SPAWNPOS_ABS
		else
			randomportal = math.floor(math.random(1, num))
		end
		if forgetit == false then
			portalpos = NETHER_PORTALS_TO_NETHER[randomportal]
		end
	else
		num = table.getn(NETHER_PORTALS_FROM_NETHER)
		if num == 1 then
			randomportal = 1
		elseif num < 1 then
			forgetit = true
			teleportpos = NETHER_SPAWNPOS_ABS
		else
			randomportal = math.floor(math.random(1, num))
		end
		if forgetit == false then
			portalpos = NETHER_PORTALS_FROM_NETHER[randomportal]
		end
	end
	if forgetit == false then
		teleportpos = {x=portalpos.x + coin2, y=portalpos.y + 1, z=portalpos.z + coin}
	end
	player:setpos(teleportpos)
end

-- Creates a portal
function nether:createportal(pos)
	local currx
	local curry
	local currz
	local currpos = {}
	for i,v in ipairs(NETHER_PORTAL) do
		currx = v.pos.x + pos.x
		curry = v.pos.y + pos.y
		currz = v.pos.z + pos.z
		currpos = {x=currx, y=curry, z=currz}
		minetest.add_node(currpos, {name=v.block})
	end
end

-- Portal Creator
minetest.register_node("nether:portal_creator", {
	tiles = {"nether_portal_creator.png"},
	description = "Nether Portal Creator",
})

minetest.register_on_placenode(function(pos, node)
	if node.name == "nether:portal_creator" then
		if nether:inside_nether(pos) then
			NETHER_PORTALS_FROM_NETHER[table.getn(NETHER_PORTALS_FROM_NETHER)+1] = pos
			nether:save_portal_from_nether(pos)
		else
			NETHER_PORTALS_TO_NETHER[table.getn(NETHER_PORTALS_TO_NETHER)+1] = pos
			nether:save_portal_to_nether(pos)
		end
		nether:createportal(pos)
	end
	nodeupdate(pos)
end)

minetest.register_abm({
	nodenames = "nether:portal_creator",
	interval = 1,
	chance = 1,
	action = function(pos)
		nether:createportal(pos)
	end
})

-- Portal Stuff
minetest.register_node("nether:portal", {
	description = "Nether Portal",
	drawtype = "glasslike",
	tiles = {"nether_portal_stuff.png"},
	inventory_image = "nether_portal_stuff.png",
	wield_image = "nether_portal_stuff.png",
	light_source = LIGHT_MAX - 2,
	paramtype = "light",
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = false,
	digable = false,
	pointable = false,
	legacy_wallmounted = false,
--	buildable_to = true,
	drop = "",
	groups = {not_in_creative_inventory=1},
	post_effect_color = {a=200, r=50, g=0, b=60},
	metadata_name = "generic"
})

minetest.register_abm({
	nodenames = {"nether:portal"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		minetest.add_particlespawner(
			32, --amount
			4, --time
			{x=pos.x-0.47, y=pos.y-0.5, z=pos.z-1}, --minpos
			{x=pos.x+0.47, y=pos.y+0.34, z=pos.z+1}, --maxpos
			{x=0, y=1, z=0}, --minvel
			{x=0, y=2, z=0}, --maxvel
			{x=-0.5,y=-3,z=-0.3}, --minacc
			{x=0.5,y=-0.4,z=0.3}, --maxacc
			1, --minexptime
			2, --maxexptime
			0.4, --minsize
			3, --maxsize
			true, --collisiondetection
			"nether_portal_particle.png" --texture
		)
		local objs = minetest.get_objects_inside_radius(pos, 1)
		if objs[1] ~= nil then
			local nodemeta = minetest.get_meta(pos)
			for _,obj in pairs(objs) do
				local objpos = obj:getpos()
				local objmeta = minetest.get_meta(objpos)
				local objplayername = obj:get_player_name()
				if objpos.y > pos.y-1
				and objpos.y < pos.y
				and objplayername ~= nil
				and objplayername ~= "" then
					local innether = nether:inside_nether(obj:getpos())
					local objstring1 = objmeta:get_string("teleportingfromnether")
					if innether
					and (
						objstring1 == "" 
						or objstring1 == nil
					) then
						objmeta:set_string("teleportingfromnether", "true")
						objmeta:set_string("teleportingtonether", "")
						nether:teleport_player(innether, obj)
						return
					end
					local objstring2 = objmeta:get_string("teleportingtonether")
					if not innether
					and (
						objstring2 == ""
						or objstring2 == nil
					) then
						objmeta:set_string("teleportingtonether", "true")
						objmeta:set_string("teleportingfromnether", "")
						nether:teleport_player(innether, obj)
					end
				end
			end
		end
	end,
})

-- CRAFTING DEFINITIONS
minetest.register_craft({
	output = "nether:portal_creator",
	recipe = {
		{"default:obsidian", "default:obsidian", "default:obsidian"},
		{"default:obsidian", "nether:pearl", "default:obsidian"},
		{"default:obsidian", "default:obsidian", "default:obsidian"},
	}
})

print("Nether mod loaded!")
