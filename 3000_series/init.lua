-- The coupler to join the two halves together
advtrains.register_coupler_type("3000_series", "3000 Series")

local train_def = {
    craft = {
        output = "subways_3000_series_lead:3000_series_lead",
        recipe = {
            {"default:steelblock", "", "default:steelblock"},
            {"xpanes:pane_flat", "dye:red", "xpanes:pane_flat"},
            {"advtrains:wheel", "", "advtrains:wheel"},
        },
    },
    displays = {
        {
            background_size = 120,
            display = "outside_first_line",
            offset = {x = 16, y = 7},
            slot = 2,
        },
        {
            background_size = 140,
            display = "outside_first_line",
            offset = {x = 16, y = 5},
            slot = 3,
        },
    },
    livery_def = {
        livery_template = {
            name = "3000 Series Lead",
            designer = "Sam Matzko",
            texture_license = "CC-BY-SA-3.0",
            texture_creator = "Sam Matzko",
            notes = "Color overrides for exterior accents.",
            base_textures = {
                "3000_series_lead.png",
            },
            overlays = {
                [1] = {name = "Primary Exterior Accents", slot_idx = 1, texture = "3000_series_lead_livery.png", alpha = 255},
                [2] = {name = "Secondary Exterior Accents", slot_idx = 1, texture = "3000_series_lead_livery_secondary.png", alpha = 255},
            },
        },
        predefined_livery = {
            name = "Standard Red",
            notes = "The default red color scheme.",
            livery_design = {
                livery_template_name = "3000 Series Lead",
                overlays = {
                    [1] = {id = 1, color = "#ff0000"},
                    [2] = {id = 2, color = "#ffa7a7"},
                },
            },
        },
    },
    wagon_def = {
        mesh = "3000_series_lead.b3d",
        textures = {
            "3000_series_lead.png",
            "subways_displays.png",
            "subways_displays.png",
        },
        base_texture = "3000_series_lead.png",
        base_texture_size = 512,
        light_texture_backwards = "3000_series_backwards.png",
        light_texture_forwards = "3000_series_forwards.png",
        light_texture_pos = {x = 0, y = 0},
        drives_on = {default = true},
        max_speed = 15,
        seats = {
            {
                name = "driver_stand",
                attach_offset = {x = -4, y = 2, z = 28},
                view_offset = {x = 0, y = 0, z = 0},
                group = "driver_stand",
            },
            {
                name = "1",
                attach_offset = {x = 5, y = 2, z = 5},
                view_offset = {x = 0, y = 0, z = 0},
                group = "passenger",
            },
            {
                name = "2",
                attach_offset = {x = -5, y = 2, z = 5},
                view_offset = {x = 0, y = 0, z = 0},
                group = "passenger",
            },
            {
                name = "3",
                attach_offset = {x = 5, y = 2, z = -2},
                view_offset = {x = 0, y = 0, z = 0},
                group = "passenger",
            },
            {
                name = "4",
                attach_offset = {x = -5, y = 2, z = -2},
                view_offset = {x = 0, y = 0, z = 0},
                group = "passenger",
            },
            {
                name = "5",
                attach_offset = {x = 5, y = 2, z = -7},
                view_offset = {x = 0, y = 0, z = 0},
                group = "passenger",
            },
            {
                name = "6",
                attach_offset = {x = -5, y = 2, z = -7},
                view_offset = {x = 0, y = 0, z = 0},
                group = "passenger",
            },
            {
                name = "7",
                attach_offset = {x = 5, y = 2, z = -30},
                view_offset = {x = 0, y = 0, z = 0},
                group = "passenger",
            },
            {
                name = "8",
                attach_offset = {x = -5, y = 2, z = -30},
                view_offset = {x = 0, y = 0, z = 0},
                group = "passenger",
            },
        },
        seat_groups = {
            driver_stand = {
                name = "Driver Stand",
                access_to = {"passenger"},
                require_doors_open = true,
                driving_ctrl_access = true,
            },
            passenger = {
                name = "Passenger",
                access_to = {"driver_stand"},
                require_doors_open = true,
                driving_ctrl_access = false,
            },
        },
        door_entry = {0, 0},
        coupler_types_back = {a3000_series = true},
        coupler_types_front = {shibata = true},
        assign_to_seat_group = {"passenger", "driver_stand"},
        is_locomotive = true,
        wagon_span = 3.570,
        wheel_positions = {2.5, -2.5},
        collisionbox = {
            -1.0, -0.5, -1.0,
            1.0, 2.5, 1.0,
        },
    },
}

local train_intermediate_def = {
    craft = {
        output = "subways_3000_series_intermediate:3000_series_intermediate",
        recipe = {
            {"default:steelblock", "", "default:steelblock"},
            {"xpanes:pane_flat", "dye:red", "xpanes:pane_flat"},
            {"advtrains:wheel", "", "advtrains:wheel"},
        },
    },
    displays = {
        {
            background_size = 120,
            display = "outside_first_line",
            offset = {x = 16, y = 13},
            slot = 2,
        },
        {
            background_size = 140,
            display = "outside_first_line",
            offset = {x = 16, y = 2},
            slot = 3,
        },
    },
    livery_def = {
        livery_template = {
            name = "3000 Series Intermediate",
            designer = "Sam Matzko",
            texture_license = "CC-BY-SA-3.0",
            texture_creator = "Sam Matzko",
            notes = "Color overrides for exterior accents.",
            base_textures = {
                "3000_series_intermediate.png",
            },
            overlays = {
                [1] = {name = "Primary Exterior Accents", slot_idx = 1, texture = "3000_series_intermediate_livery.png", alpha = 255},
                [2] = {name = "Secondary Exterior Accents", slot_idx = 1, texture = "3000_series_intermediate_livery_secondary.png", alpha = 255},
            },
        },
        predefined_livery = {
            name = "Standard Red",
            notes = "The default red color scheme.",
            livery_design = {
                livery_template_name = "3000 Series Intermediate",
                overlays = {
                    [1] = {id = 1, color = "#ff0000"},
                    [2] = {id = 2, color = "#ffa7a7"},
                },
            },
        },
    },
    wagon_def = {
        mesh = "3000_series_intermediate.b3d",
        textures = {
            "3000_series_intermediate.png",
            "subways_displays.png",
            "subways_displays.png",
        },
        base_texture = "3000_series_intermediate.png",
        base_texture_size = 512,
        light_texture_backwards = "subways_displays.png",
        light_texture_forwards = "subways_displays.png",
        light_texture_pos = {x = 0, y = 0},
        drives_on = {default = true},
        max_speed = 15,
        seats = {
            {
                name = "1",
                attach_offset = {x = 5, y = 2, z = 0},
                view_offset = {x = 0, y = 0, z = 0},
                group = "passenger",
            },
            {
                name = "2",
                attach_offset = {x = -5, y = 2, z = 0},
                view_offset = {x = 0, y = 0, z = 0},
                group = "passenger",
            },
            {
                name = "3",
                attach_offset = {x = 5, y = 2, z = -6},
                view_offset = {x = 0, y = 0, z = 0},
                group = "passenger",
            },
            {
                name = "4",
                attach_offset = {x = -5, y = 2, z = -6},
                view_offset = {x = 0, y = 0, z = 0},
                group = "passenger",
            },
            {
                name = "5",
                attach_offset = {x = 5, y = 2, z = 6},
                view_offset = {x = 0, y = 0, z = 0},
                group = "passenger",
            },
            {
                name = "6",
                attach_offset = {x = -5, y = 2, z = 6},
                view_offset = {x = 0, y = 0, z = 0},
                group = "passenger",
            },
            {
                name = "7",
                attach_offset = {x = 5, y = 2, z = -28},
                view_offset = {x = 0, y = 0, z = 0},
                group = "passenger",
            },
            {
                name = "8",
                attach_offset = {x = -5, y = 2, z = -28},
                view_offset = {x = 0, y = 0, z = 0},
                group = "passenger",
            },
            {
                name = "9",
                attach_offset = {x = -5, y = 2, z = 28},
                view_offset = {x = 0, y = 0, z = 0},
                group = "passenger",
            },
            {
                name = "10",
                attach_offset = {x = -5, y = 2, z = 28},
                view_offset = {x = 0, y = 0, z = 0},
                group = "passenger",
            },
        },
        seat_groups = {
            passenger = {
                name = "Passenger",
                access_to = {},
                require_doors_open = true,
                driving_ctrl_access = false,
            },
        },
        door_entry = {0, 0},
        coupler_types_back = {a3000_series = true},
        coupler_types_front = {a3000_series = true},
        assign_to_seat_group = {"passenger", "driver_stand"},
        is_locomotive = false,
        wagon_span = 3.450,
        wheel_positions = {2.5, -2.5},
        collisionbox = {
            -1.0, -0.5, -1.0,
            1.0, 2.5, 1.0,
        },
    },
}

subways.register_subway("3000_series_lead", train_def, "3000 Series Lead", "3000_series_lead_inv.png")
subways.register_subway("3000_series_intermediate", train_intermediate_def, "3000 Series Intermediate", "3000_series_intermediate_inv.png")
