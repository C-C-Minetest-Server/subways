local S
if minetest.get_modpath("intllib") then
    S = intllib.Getter()
else
    S = function(s,a,...)a={a,...}return s:gsub("@(%d+)",function(n)return a[tonumber(n)]end)end
end

local use_attachment_patch = advtrains_attachment_offset_patch and advtrains_attachment_offset_patch.setup_advtrains_wagon

-- Begin support implementation for advtrains_livery_designer

local use_advtrains_livery_designer = minetest.get_modpath("advtrains_livery_designer") and advtrains_livery_designer
local mod_name = "subways_brown_subway_wagon"

-- The templates that define the liveries
local livery_templates = {
	["advtrains:brown_subway_wagon"] = {
		{
			name = "Brown Subway Wagon",
			designer = "Sylvester Kruin",
			texture_license = "CC-BY-SA-3.0",
			texture_creator = "Sylvester Kruin",
			notes = "This template supports independent color overrides for the exterior accents.",

			base_textures = {
				"b_coupler.png",
				"b_cube.png",
				"b_doors.png",
				"b_seat.png",
				"b_undercarriage.png",
				"b_wagon_exterior.png",
				"b_wagon_interior.png",
				"b_wheels.png",
			},
			overlays = {
				[1] = {name = "Window Stripe", slot_idx = 6, texture = "b_wagon_exterior_overlay.png", alpha = 255},
				[2] = {name = "Door Livery",   slot_idx = 3, texture = "b_doors_overlay.png",          alpha = 255},
				[3] = {name = "Seat Color",    slot_idx = 4, texture = "b_seat_overlay.png",           alpha = 240},
				[4] = {name = "Carpet Color",  slot_idx = 7, texture = "b_wagon_interior_overlay.png", alpha = 240},
			}
		}
	}
}

-- Predefined liveries
local predefined_liveries = {
	{
		name = "Classic Brown",
		notes = "A classic brown livery",
		livery_design = {
			livery_template_name = "Brown Subway Wagon",
			overlays = {
				[1] = {id = 1, color = "#7D5343"},
				[2] = {id = 2, color = "#FFFFFF"},
				[3] = {id = 3, color = "#970000"},
				[4] = {id = 4, color = "#933415"}
			}
		}
	}
}

if use_advtrains_livery_designer then
	-- This function is called by the advtrains_livery_designer tool whenever the player
	-- activates the "Apply" button.
	-- This implementation is specific to brown_subway_wagon. A more complex
	-- implementation may be needed if other wagons or livery templates are added.
	local function apply_wagon_livery_textures(player, wagon, textures)
		if wagon and textures and textures[1] then
			local data = advtrains.wagons[wagon.id]
			data.livery = textures[6]
			data.door = textures[3]
			data.seats = textures[4]
			data.floor = textures[7]
			wagon:set_textures(data)
		end
	end

	-- Register this mod and its livery function with the advtrains_livery_designer tool.
	advtrains_livery_designer.register_mod(mod_name, apply_wagon_livery_textures)

	-- Register this mod's wagons and livery templates.
	for wagon_type, wagon_livery_templates in pairs(livery_templates) do
		advtrains_livery_database.register_wagon(wagon_type, mod_name)
		for _, livery_template in ipairs(wagon_livery_templates) do
			advtrains_livery_database.add_livery_template(
				wagon_type,
				livery_template.name,
				livery_template.base_textures,
				mod_name,
				(livery_template.overlays and #livery_template.overlays) or 0,
				livery_template.designer,
				livery_template.texture_license,
				livery_template.texture_creator,
				livery_template.notes
			)
			if livery_template.overlays then
				for overlay_id, overlay in ipairs(livery_template.overlays) do
					advtrains_livery_database.add_livery_template_overlay(
						wagon_type,
						livery_template.name,
						overlay_id,
						overlay.name,
						overlay.slot_idx,
						overlay.texture,
						overlay.alpha
					)
				end
			end
		end
	end

	-- Register this mod's predefined wagon liveries.
	for _, predefined_livery in ipairs(predefined_liveries) do
		local livery_design = predefined_livery.livery_design
		livery_design.wagon_type = "advtrains:brown_subway_wagon"
		advtrains_livery_database.add_predefined_livery(
			predefined_livery.name,
			livery_design,
			mod_name,
			predefined_livery.notes
		)
	end
end

local function update_livery(wagon, puncher)
	local itemstack = puncher:get_wielded_item()
	local item_name = itemstack:get_name()
	if use_advtrains_livery_designer and item_name == advtrains_livery_designer.tool_name then
		advtrains_livery_designer.activate_tool(puncher, wagon, mod_name)
		return true
	end
	return false
end

-- End of support code for advtrains_livery_designer

local function set_textures(self, data)
	if data.livery then
		self.livery = data.livery
		self.door_livery_data = data.door
		self.seat_livery_data = data.seats
		self.floor_livery_data = data.floor
		self.object:set_properties({
				textures={
					"b_coupler.png",
					"b_cube.png",
					data.door,
					data.seats,
					"b_undercarriage.png",
					data.livery,
					data.floor,
					"b_wheels.png",
				}
		})
	end
end

-- The definition for brown_subway_locomotive
local subway_locomotive_def = {
    mesh="brown_subway_locomotive.b3d",
    textures = {
		"b_coupler.png",
		"b_cube.png",
		"b_doors.png",
		"b_seat.png",
		"b_undercarriage.png",
		"b_wagon_exterior.png",
		"b_wagon_interior.png",
		"b_wheels.png",
	},
	base_texture = "b_wagon_exterior.png",
	base_livery = "b_wagon_exterior_overlay.png",
	seat_texture = "b_seat.png",
	door_texture = "b_doors.png",
	set_textures = set_textures,
    drives_on={default=true},
    max_speed=15,
	custom_may_destroy = function(wagon, puncher, time_from_last_punch, tool_capabilities, direction)
		return not update_livery(wagon, puncher)
	end,
	custom_on_step = function(self, dtime, data, train)
		-- Set the line number for the train
		local line = ""
		local line_number = tonumber(train.line)
		if line_number and line_number <= 9 and line_number > 0 then
			line = "^b_line_"..train.line..".png"
		end
		if self.livery then
			self.object:set_properties({
				textures={
					"b_coupler.png",
					"b_cube.png",
					self.door_livery_data,
					self.seat_livery_data,
					"b_undercarriage.png",
					self.livery..line,
					self.floor_livery_data,
					"b_wheels.png",
				}
			})
		else
			self.object:set_properties({
				textures={
					"b_coupler.png",
					"b_cube.png",
					"b_doors.png",
					"b_seat.png",
					"b_undercarriage.png",
					"b_wagon_exterior.png"..line,
					"b_wagon_interior.png",
					"b_wheels.png",
				},
			})
		end
	end,
    seats={
		{
			name="Driver stand",
			attach_offset={x=-4, y=3.5, z=26},
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="driver_stand",
		},
		-- Left side seats
        {
			name="1",
			attach_offset={x=-4, y=3.5, z=4},-- 4
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
		{
			name="2",
			attach_offset={x=-4, y=3.5, z=10},
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
		{
			name="3",
			attach_offset={x=-4, y=3.5, z=-4},
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
		{
			name="4",
			attach_offset={x=-4, y=3.5, z=-10},
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
		{
			name="5",
			attach_offset={x=-4, y=3.5, z=-28},
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
		-- Right side seats
		{
			name="6",
			attach_offset={x=4, y=3.5, z=4},-- 4
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
		{
			name="7",
			attach_offset={x=4, y=3.5, z=10},
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
		{
			name="8",
			attach_offset={x=4, y=3.5, z=-4},
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
		{
			name="9",
			attach_offset={x=4, y=3.5, z=-10},
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
		{
			name="10",
			attach_offset={x=4, y=3.5, z=-28},
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
    },
    seat_groups = {
		driver_stand={
			name = "Driver Stand",
			access_to = {"passenger"},
			require_doors_open=true,
			driving_ctrl_access=true,
		},
        passenger={
			name = "Passenger Area",
			access_to = {"driver_stand"},
			require_doors_open=true,
		},
	},
    assign_to_seat_group={"passenger", "driver_stand"},
    door_entry={-1, 1},
	doors={
		open={
			[-1]={frames={x=0, y=20}, time=1},
			[1]={frames={x=40, y=60}, time=1}
		},
		close={
			[-1]={frames={x=20, y=40}, time=1},
			[1]={frames={x=60, y=80}, time=1}
		}
	},
    is_locomotive=true,
	drops={"default:steelblock 4"},
    visual_size={x=1, y=1},
	wagon_span=3.45,
	collisionbox = {
		-1.0, -0.5, -1.0,
		1.0, 2.5, 1.0
	},
}

-- The definition for brown_subway_wagon
local subway_wagon_def = {
    mesh="brown_subway_wagon.b3d",
    textures = {
		"b_coupler.png",
		"b_cube.png",
		"b_doors.png",
		"b_seat.png",
		"b_undercarriage.png",
		"b_wagon_exterior.png",
		"b_wagon_interior.png",
		"b_wheels.png",
	},
	base_texture = "b_wagon_exterior.png",
	base_livery = "b_wagon_exterior_overlay.png",
	seat_texture = "b_seat.png",
	door_texture = "b_doors.png",
	set_textures = set_textures,
    drives_on={default=true},
    max_speed=15,
	custom_may_destroy = function(wagon, puncher, time_from_last_punch, tool_capabilities, direction)
		return not update_livery(wagon, puncher)
	end,
	custom_on_step = function(self, dtime, data, train)
		-- Set the line number for the train
		local line = ""
		local line_number = tonumber(train.line)
		if line_number and line_number <= 9 and line_number > 0 then
			line = "^b_line_"..train.line..".png"
			print("Line update was successful")
		end
		if self.livery then
			self.object:set_properties({
				textures={
					"b_coupler.png",
					"b_cube.png",
					self.door_livery_data,
					self.seat_livery_data,
					"b_undercarriage.png",
					self.livery..line,
					self.floor_livery_data,
					"b_wheels.png",
				}
			})
		else
			self.object:set_properties({
				textures={
					"b_coupler.png",
					"b_cube.png",
					"b_doors.png",
					"b_seat.png",
					"b_undercarriage.png",
					"b_wagon_exterior.png"..line,
					"b_wagon_interior.png",
					"b_wheels.png",
				},
			})
		end
	end,
    seats={
		-- Left side seats
        {
			name="1",
			attach_offset={x=-4, y=3.5, z=4},-- 4
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
		{
			name="2",
			attach_offset={x=-4, y=3.5, z=10},
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
		{
			name="3",
			attach_offset={x=-4, y=3.5, z=-4},
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
		{
			name="4",
			attach_offset={x=-4, y=3.5, z=-10},
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
		{
			name="5",
			attach_offset={x=-4, y=3.5, z=-28},
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
		-- Right side seats
		{
			name="6",
			attach_offset={x=4, y=3.5, z=4},-- 4
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
		{
			name="7",
			attach_offset={x=4, y=3.5, z=10},
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
		{
			name="8",
			attach_offset={x=4, y=3.5, z=-4},
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
		{
			name="9",
			attach_offset={x=4, y=3.5, z=-10},
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
		{
			name="10",
			attach_offset={x=4, y=3.5, z=-28},
			view_offset=use_attachment_patch and {x=0, y=0, z=0} or {x=0, y=3.5, z=0},
			group="passenger",
		},
    },
    seat_groups = {
        passenger={
			name = "Passenger Area",
			access_to = {},
			require_doors_open=true,
		},
	},
    assign_to_seat_group={"passenger"},
    door_entry={-1, 1},
	doors={
		open={
			[-1]={frames={x=0, y=20}, time=1},
			[1]={frames={x=40, y=60}, time=1}
		},
		close={
			[-1]={frames={x=20, y=40}, time=1},
			[1]={frames={x=60, y=80}, time=1}
		}
	},
    is_locomotive=false,
	drops={"default:steelblock 4"},
    visual_size={x=1, y=1},
	wagon_span=3.45,
	collisionbox = {
		-1.0, -0.5, -1.0,
		1.0, 2.5, 1.0
	},
}

-- Enable support for advtrains_attachment_offset_patch
if use_attachment_patch then
	advtrains_attachment_offset_patch.setup_advtrains_wagon(subway_locomotive_def)
	advtrains_attachment_offset_patch.setup_advtrains_wagon(subway_wagon_def)
end

-- Register the wagon and locomotive
advtrains.register_wagon("brown_subway_locomotive", subway_locomotive_def, "Brown Subway Locomotive", "b_inv_locomotive.png")
advtrains.register_wagon("brown_subway_wagon", subway_wagon_def, "Brown Subway Car", "b_inv_wagon.png")

-- Craft recipes
minetest.register_craft({
	output="advtrains:brown_subway_wagon",
	recipe={
		{"default:steelblock", "default:steelblock", "default:steelblock"},
		{"xpanes:pane_flat", "dye:brown", "xpanes:pane_flat"},
		{"advtrains:wheel", "", "advtrains:wheel"}
	}
})
minetest.register_craft({
	output="advtrains:brown_subway_locomotive",
	recipe={
		{"", "", ""},
		{"default:steelblock", "advtrains:brown_subway_wagon", "default:steelblock"},
		{"", "", ""},
	}
})
