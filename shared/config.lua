Config = {}
Config.TeleportIn = vec4(5.79, -709.24, 16.13, 341.16)
Config.TeleportOut = vec4(10.23, -667.79, 33.45, 359.0)
Config.Cameras = {
    --[[
    [1] = {
        coords = vec3(-6.8854370117188, -685.77014160156, 18.607206344604),
        heading = 10,
        modelHash = -937756226,
    },
    [2] = {
        coords = vec3(-7.2580509185791, -686.830078125, 18.607095718384),
        heading = 120,
        modelHash = -937756226,
    },
    ]]
    [1] = {
        coords = vec3(7.7298274040222, -709.6572265625, 18.608377456665),
        heading = 180,
        modelHash = -937756226,
    },
    --[[
    [4] = {
        coords = vec3(-15.377056121826, -696.82501220703, 18.607481002808),
        heading = 100,
        modelHash = -937756226,
    },
    ]]
    
}

Config.Guards = {
    [1] = {
        coords = vec4(4.11, -666.02, 16.13, 160.95),
        model = "s_m_m_security_01",
        weapon = "WEAPON_CARBINERIFLE",
        accuracy = 75,
        health = 300,
        armor = 100,
        combatMovement = 2, -- {0 = Stationary | 1 = Defensive | 2 = Offensive | 3 = Suicidal Offensive}
        rewards = {
            [1] = {item = "thermite", amount = 1, chance = 50},
        }
    },
    --[[
    [2] = {
        coords = vec4(-8.18, -680.37, 16.13, 253.6),
        model = "s_m_m_security_01",
        weapon = "WEAPON_CARBINERIFLE",
        accuracy = 75,
        health = 300,
        armor = 100,
        combatMovement = 2 -- {0 = Stationary | 1 = Defensive | 2 = Offensive | 3 = Suicidal Offensive}
    },
    [3] = {
        coords = vec4(-3.45, -665.13, 16.13, 256.28),
        model = "s_m_m_security_01",
        weapon = "WEAPON_CARBINERIFLE",
        accuracy = 75,
        health = 300,
        armor = 100,
        combatMovement = 2 -- {0 = Stationary | 1 = Defensive | 2 = Offensive | 3 = Suicidal Offensive}
    },
    [4] = {
        coords = vec4(10.96, -669.66, 16.13, 71.83),
        model = "s_m_m_security_01",
        weapon = "WEAPON_CARBINERIFLE",
        accuracy = 75,
        health = 300,
        armor = 100,
        combatMovement = 2 -- {0 = Stationary | 1 = Defensive | 2 = Offensive | 3 = Suicidal Offensive}
    },
    [5] = {
        coords = vec4(0.32, -675.51, 16.13, 160.49),
        model = "s_m_m_security_01",
        weapon = "WEAPON_CARBINERIFLE",
        accuracy = 75,
        health = 300,
        armor = 100,
        combatMovement = 2 -- {0 = Stationary | 1 = Defensive | 2 = Offensive | 3 = Suicidal Offensive}
    },
    [6] = {
        coords = vec4(3.4, -684.64, 16.13, 80.24),
        model = "s_m_m_security_01",
        weapon = "WEAPON_CARBINERIFLE",
        accuracy = 75,
        health = 300,
        armor = 100,
        combatMovement = 2 -- {0 = Stationary | 1 = Defensive | 2 = Offensive | 3 = Suicidal Offensive}
    }
    ]]
}

Config.Vault = {
    coords = vec4(-1.7279472351074, -686.54174804688, 16.689130783081, 160.071),
    size = vec3(3, 1, 2),
    required = {item = "thermite", amount = 1},
    debug = false,
}

Config.GasGrenades = {
    enabled = true,
    locations = {
        [1] = {
            coords = vec3(-6.18, -677.19, 15.5),
        }
    }
}

Config.HackLocations = {
    [1] = {
        coords = vec4(2.35, -689, 16.5, 250),
        size = vec3(1, 0.5, 2),
        label = "Blow Up",
        required = {item = "electronickit", amount = 1},
        debug = true,
    },
    [2] = {
        coords = vec4(-5.40, -700.61, 16.5, 161.25),
        size = vec3(1, 0.5, 2),
        label = "Blow Up",
        required = {item = "electronickit", amount = 1},
        debug = true,
    },
    [3] = {
        coords = vec4(2.2, -698.17, 16.5, 341.49),
        size = vec3(1, 0.5, 2),
        label = "Blow Up",
        required = {item = "electronickit", amount = 1},
        debug = true,
    },
    [4] = {
        coords = vec4(10, -707.05, 16.5, 254.05),
        size = vec3(1, 0.5, 2),
        label = "Blow Up",
        required = {item = "electronickit", amount = 1},
        debug = true,
    }    
}

Config.DoorLocations = {
    [1] = {
        coords = vec4(-2.9891357421875, -676.64025878906, 16.358602523804, -110),
        modelHash = -1011692606,
        size = vec3(1.5, 0.5, 2),
        targetModifier = vec3(0, -0.75, 0),
        pedHeading = 120,
        explosionXModifier = -0.3,
        explosionYModifier = -1,
        debug = true,
    },
    [2] = {
        coords = vec4(-7.4042434692383, -678.65899658203, 16.358606338501, -20.029),
        modelHash = -1011692606,
        size = vec3(1.5, 0.25, 2),
        targetModifier = vec3(0.75, -0.45, 0),
        pedHeading = 344,
        explosionXModifier = 0.75,
        explosionYModifier = -0.45,
        debug = true,
    },
    [3] = {
        coords = vec4(4.3517322540283, -682.93389892578, 16.358606338501, 160.037),
        modelHash = -1011692606,
        size = vec3(1.5, 0.25, 2),
        targetModifier = vec3(-0.75, 0.1, 0),
        pedHeading = 344,
        explosionXModifier = -0.75,
        explosionYModifier = 0.1,
        debug = true,
    }
}

Config.Loot = {
    [1] = {
        coords = vec4(-8.630, -676.709, 15.141, 160.327),
        size = vec3(1.65, 1.2, 3),
        models = {
            {modelHash = 1483319544, chance = 20}, -- 50% chance to spawn
            {modelHash = -1802035584, chance = 10}, -- 30% chance to spawn
            {modelHash = -1324034181, chance = 10},  -- 20% chance to spawn
            {modelHash = -1479600188, chance = 60}  -- 20% chance to spawn
        }
    },
    [2] = {
        coords = vec4(-7.643, -673.846, 15.141, 160.327),
        size = vec3(1.65, 1.2, 3),
        models = {
            {modelHash = 1483319544, chance = 20}, -- 50% chance to spawn
            {modelHash = -1802035584, chance = 10}, -- 30% chance to spawn
            {modelHash = -1324034181, chance = 10},  -- 20% chance to spawn
            {modelHash = -1479600188, chance = 60}  -- 20% chance to spawn
        }
    },
    [3] = {
        coords = vec4(-3.629, -675.651, 15.141, 72.616),
        size = vec3(1.05, 0.8, 2.1),
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },
    [4] = {
        coords = vec4(-4.557, -678.313, 15.141, 72.616),
        size = vec3(1.05, 0.8, 2.1),
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    }
}

-- The below props are all spawned by the interior. For the purposes of this heist, I'm deleting ALL of the below props.
-- DO NOT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING
Config.DeleteProps = {
    -- Cage 1
    [1] = {
        coords = vec3(-8.3409881591797, -675.3349609375, 15.219604492188),
        modelHash = 307713837,
    },
    [2] = {
        coords = vec3(-6.7879343032837, -675.09967041016, 15.132299423218),
        modelHash = -2018598162
    },
    [3] = {
        coords = vec3(-7.7216439247131, -673.84674072266, 15.141380310059),
        modelHash = -2022916910
    },
    [4] = {
        coords = vec3(-6.4749183654785, -673.98638916016, 15.132393836975),
        modelHash = -2018598162
    },
    [5] = {
        coords = vec3(-5.134391784668, -674.39624023438, 15.220226287842),
        modelHash = -1685625437
    },
    [6] = {
        coords = vec3(-5.5497136116028, -675.37438964844, 15.132568359375),
        modelHash = -1474093273
    },
    [7] = {
        coords = vec3(-4.0560803413391, -674.64404296875, 15.220150947571),
        modelHash = -1685625437
    },
    [8] = {
        coords = vec3(-4.8025970458984, -678.67999267578, 15.219604492188),
        modelHash = 307713837
    },
    [9] = {
        coords = vec3(-8.8994197845459, -676.62939453125, 15.142498970032),
        modelHash = -2022916910,
    },

    -- Cage 2
    [10] = {
        coords = vec3(3.551908493042, -677.45397949219, 15.602298736572),
        modelHash = 929864185,
    },
    [11] = {
        coords = vec3(5.7710666656494, -678.46520996094, 15.138112068176),
        modelHash = -2022916910,
    },
    [12] = {
        coords = vec3(6.7759852409363, -678.88610839844, 15.220540046692),
        modelHash = -1685625437,
    },
    [13] = {
        coords = vec3(6.2679080963135, -679.89819335938, 15.130056381226),
        modelHash = -1474093273,
    },
    [14] = {
        coords = vec3(7.8298244476318, -679.15496826172, 15.220226287842),
        modelHash = -1685625437,
    },
    [15] = {
        coords = vec3(7.4471101760864, -680.29565429688, 15.130056381226),
        modelHash = -2022916910,
    },
    [16] = {
        coords = vec3(6.6410665512085, -682.73120117188, 15.130056381226),
        modelHash = -2022916910,
    },
    [17] = {
        coords = vec3(2.4265623092651, -681.16436767578, 15.219604492188),
        modelHash = 307713837,
    },

    -- Stranded Objects
    [18] = {
        coords = vec3(3.397611618042, -686.74658203125, 15.130056381226),
        modelHash = -1474093273,
    },
    [19] = {
        coords = vec3(4.4687194824219, -687.10778808594, 15.130056381226),
        modelHash = -1474093273,
    },
    [20] = {
        coords = vec3(-10.121774673462, -681.74633789062, 15.130056381226),
        modelHash = -1474093273,
    },
    [21] = {
        coords = vec3(-9.2964096069336, -678.93395996094, 15.130056381226),
        modelHash = -1474093273,
    },
    [22] = {
        coords = vec3(-4.7663788795471, -666.72692871094, 15.13249874115),
        modelHash = -1474093273,
    },
    [23] = {
        coords = vec3(10.538780212402, -671.17254638672, 15.132376670837),
        modelHash = -1474093273,
    },
    [24] = {
        coords = vec3(10.212304115295, -672.2314453125, 15.130056381226),
        modelHash = -1474093273,
    },
}