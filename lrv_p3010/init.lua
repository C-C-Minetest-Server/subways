-- The coupler to join the two halves together
advtrains.register_coupler_type("lrv_p3010", "LRV P3010")

local train_def = {
    craft = {
        output = "subways_lrv_p3010:lrv_p3010",
        recipe = {
            {"default:steelblock", "default:steelblock", "default:steelblock"},
            {"xpanes:pane_flat", "dye:yellow", "xpanes:pane_flat"},
            {"advtrains:wheel", "", "advtrains:wheel"},
        },
    },
    displays = {},
    livery_def = {},
    wagon_def = {
        mesh = "p3010.b3d",
        textures = {
            "p3010.png",
        },
        base_texture = "p3010.png",
        base_texture_size = 256,
        light_texture_backwards = "p3010_backwards.png",
        light_texture_forwards = "p3010_forwards.png",
        light_texture_pos = {x = 0, y = 0},
        drives_on = {default = true},
        max_speed = 15,
        seats = {
            {
                name = "driver_stand",
                attach_offset = {x = 0, y = 0, z = 0},
                view_offset = {x = 0, y = 0, z = 0},
                group = "driver_stand",
            },
        },
        seat_groups = {
            driver_stand = {
                name = "Driver Stand",
                access_to = {},
                require_doors_open = true,
                driving_ctrl_access = true,
            },
        },
        door_entry = {0, 0},
        coupler_types_back = {lrv_p3010 = true},
        coupler_types_front = {tomlinson = true},
        assign_to_seat_group = {"driver_stand"},
        is_locomotive = true,
        wagon_span = 3.600,
        wheel_positions = {1, -1},
        collisionbox = {
            -1.0, -0.5, -1.0,
            1.0, 2.5, 1.0,
        },
    },
}

subways.register_subway("lrv_p3010", train_def, "LRV P3010", "p3010_inv.png")
