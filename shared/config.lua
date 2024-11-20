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
        cage = 1,
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
        cage = 1,
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
        cage = 1,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },
    [4] = {
        coords = vec4(-4.557, -678.313, 15.141, 72.616),
        size = vec3(1.05, 0.8, 2.1),
        cage = 1,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },

    -- Cage 2
    [5] = {
        coords = vec4(2.35933494567871, -680.9426879882812, 15.141, -110.425),
        size = vec3(1.05, 0.8, 2.1),
        cage = 2,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },
    [6] = {
        coords = vec4(3.26235651969909, -678.2145385742188, 15.141, 70.643),
        size = vec3(1.05, 0.8, 2.1),
        cage = 2,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },
    [7] = {
        coords = vec4(6.4910802841187, -682.59210205078, 15.141, 70.254),
        size = vec3(1.05, 0.8, 2.1),
        cage = 2,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },
    [8] = {
        coords = vec4(7.1166009902954, -681.14898681641, 15.141, 70.103),
        size = vec3(1.05, 0.8, 2.1),
        cage = 2,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },
    [9] = {
        coords = vec4(7.5191202163696, -679.728515625, 15.141, 71.060),
        size = vec3(1.05, 0.8, 2.1),
        cage = 2,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },


    -- Cage 3
    [10] = {
        coords = vec4(-5.936728477478, -672.54266357422, 15.141, -20.740),
        size = vec3(1.05, 0.8, 2.1),
        cage = 3,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },
    [11] = {
        coords = vec4(-6.7941837310791, -671.40014648438, 15.141, 69.834),
        size = vec3(1.05, 0.8, 2.1),
        cage = 3,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },
    [12] = {
        coords = vec4(-6.2704219818115, -670.04833984375, 15.141, 69.834),
        size = vec3(1.05, 0.8, 2.1),
        cage = 3,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },
    [13] = {
        coords = vec4(-5.7556109428406, -668.58551025391, 15.141, 69.834),
        size = vec3(1.05, 0.8, 2.1),
        cage = 3,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },
    [14] = {
        coords = vec4(-4.347936630249, -668.61016845703, 15.141, -19.731),
        size = vec3(1.05, 0.8, 2.1),
        cage = 3,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },
    [15] = {
        coords = vec4(-1.538468003273, -670.19311523438, 15.141, 68.618),
        size = vec3(1.05, 0.8, 2.1),
        cage = 3,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },
    [16] = {
        coords = vec4(-2.5635013580322, -672.90319824219, 15.141, 68.618),
        size = vec3(1.05, 0.8, 2.1),
        cage = 3,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },

    -- Cage 4
    [17] = {
        coords = vec4(8.6649103164673, -673.21044921875, 15.141, -19.786),
        size = vec3(1.05, 0.8, 2.1),
        cage = 4,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },
    [18] = {
        coords = vec4(9.4819917678833, -674.20440673828, 15.141, 69.461),
        size = vec3(1.05, 0.8, 2.1),
        cage = 4,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },
    [19] = {
        coords = vec4(8.5653009414673, -676.89196777344, 15.141, 69.461),
        size = vec3(1.05, 0.8, 2.1),
        cage = 4,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },
    [20] = {
        coords = vec4(7.1033549308777, -677.41119384766, 15.141, -19.741),
        size = vec3(1.05, 0.8, 2.1),
        cage = 4,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },
    [21] = {
        coords = vec4(4.3525218963623, -675.32373046875, 15.141, 70.329),
        size = vec3(1.05, 0.8, 2.1),
        cage = 4,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },

    [22] = {
        coords = vec4(5.3795747756958, -672.59796142578, 15.141, 70.329),
        size = vec3(1.05, 0.8, 2.1),
        cage = 4,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },

    -- Cage 5
    [23] = {
        coords = vec4(-2.2559998035431, -660.330078125, 15.141, 71.264),
        size = vec3(1.65, 1.2, 3),
        cage = 5,
        models = {
            {modelHash = 1483319544, chance = 20}, -- 50% chance to spawn
            {modelHash = -1802035584, chance = 10}, -- 30% chance to spawn
            {modelHash = -1324034181, chance = 10},  -- 20% chance to spawn
            {modelHash = -1479600188, chance = 60}  -- 20% chance to spawn
        }
    },
    [24] = {
        coords = vec4(-1.5695213079453, -658.06890869141, 15.141, 71.264),
        size = vec3(1.65, 1.2, 3),
        cage = 5,
        models = {
            {modelHash = 1483319544, chance = 20}, -- 50% chance to spawn
            {modelHash = -1802035584, chance = 10}, -- 30% chance to spawn
            {modelHash = -1324034181, chance = 10},  -- 20% chance to spawn
            {modelHash = -1479600188, chance = 60}  -- 20% chance to spawn
        }
    },
    [25] = {
        coords = vec4(0.99421143531799, -657.27581787109, 15.141, -18.817),
        size = vec3(1.65, 1.2, 3),
        cage = 5,
        models = {
            {modelHash = 1483319544, chance = 20}, -- 50% chance to spawn
            {modelHash = -1802035584, chance = 10}, -- 30% chance to spawn
            {modelHash = -1324034181, chance = 10},  -- 20% chance to spawn
            {modelHash = -1479600188, chance = 60}  -- 20% chance to spawn
        }
    },
    [26] = {
        coords = vec4(2.4948759078979, -659.18127441406, 15.141, 69.152),
        size = vec3(1.05, 0.8, 2.1),
        cage = 5,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },
    [27] = {
        coords = vec4(1.4895259141922, -661.88885498047, 15.141, 69.152),
        size = vec3(1.05, 0.8, 2.1),
        cage = 5,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },

    -- Cage 6
    [28] = {
        coords = vec4(10.139169692993, -660.56341552734, 15.141, -19.120),
        size = vec3(1.65, 1.2, 3),
        cage = 6,
        models = {
            {modelHash = 1483319544, chance = 20}, -- 50% chance to spawn
            {modelHash = -1802035584, chance = 10}, -- 30% chance to spawn
            {modelHash = -1324034181, chance = 10},  -- 20% chance to spawn
            {modelHash = -1479600188, chance = 60}  -- 20% chance to spawn
        }
    },
    [29] = {
        coords = vec4(13.065095901489, -661.58673095703, 15.141, -19.120),
        size = vec3(1.65, 1.2, 3),
        cage = 6,
        models = {
            {modelHash = 1483319544, chance = 20}, -- 50% chance to spawn
            {modelHash = -1802035584, chance = 10}, -- 30% chance to spawn
            {modelHash = -1324034181, chance = 10},  -- 20% chance to spawn
            {modelHash = -1479600188, chance = 60}  -- 20% chance to spawn
        }
    },
    [30] = {
        coords = vec4(13.403031349182, -663.33306884766, 15.141, 70.016),
        size = vec3(1.65, 1.2, 3),
        cage = 6,
        models = {
            {modelHash = 1483319544, chance = 20}, -- 50% chance to spawn
            {modelHash = -1802035584, chance = 10}, -- 30% chance to spawn
            {modelHash = -1324034181, chance = 10},  -- 20% chance to spawn
            {modelHash = -1479600188, chance = 60}  -- 20% chance to spawn
        }
    },
    [31] = {
        coords = vec4(12.375401496887, -665.96148681641, 15.141, 70.016),
        size = vec3(1.65, 1.2, 3),
        cage = 6,
        models = {
            {modelHash = 1483319544, chance = 20}, -- 50% chance to spawn
            {modelHash = -1802035584, chance = 10}, -- 30% chance to spawn
            {modelHash = -1324034181, chance = 10},  -- 20% chance to spawn
            {modelHash = -1479600188, chance = 60}  -- 20% chance to spawn
        }
    },
    [32] = {
        coords = vec4(8.3754529953003, -664.27593994141, 15.141, 69.040),
        size = vec3(1.05, 0.8, 2.1),
        cage = 6,
        models = {
            {modelHash = 929864185, chance = 60}, -- 40% chance to spawn
            {modelHash = -1326042488, chance = 40}, -- 40% chance to spawn
        }
    },

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

    -- Cage 3
    [25] = {
        coords = vec3(-2.849889755249, -673.61340332031, 15.220226287842),
        modelHash = -1685625437,
    },
    [26] = {
        coords = vec3(-4.9374771118164, -672.65380859375, 15.132097244263),
        modelHash = -2022916910,
    },
    [27] = {
        coords = vec3(-5.9237575531006, -672.23669433594, 15.220226287842),
        modelHash = -1685625437,
    },
    [28] = {
        coords = vec3(-6.999813079834, -671.95880126953, 15.220226287842),
        modelHash = -1685625437,
    },
    [29] = {
        coords = vec3(-5.4383401870728, -671.21551513672, 15.131792068481),
        modelHash = -1474093273,
    },
    [30] = {
        coords = vec3(-6.5481643676758, -670.72790527344, 15.130056381226),
        modelHash = -2022916910,
    },
    [31] = {
        coords = vec3(-6.0151138305664, -669.68908691406, 15.130056381226),
        modelHash = -2018598162,
    },
    [32] = {
        coords = vec3(-5.8809375762939, -668.41998291016, 15.130056381226),
        modelHash = -2022916910,
    },
    [33] = {
        coords = vec3(-4.4059219360352, -669.01794433594, 15.219604492188),
        modelHash = 307713837,
    },
    [34] = {
        coords = vec3(-1.5708503723145, -669.95739746094, 15.219604492188),
        modelHash = 307713837,
    },

    -- Cage 4
    [35] = {
        coords = vec3(4.0107975006104, -676.3271484375, 15.602298736572),
        modelHash = 929864185,
    },
    [36] = {
        coords = vec3(4.9934139251709, -676.68444824219, 15.602298736572),
        modelHash = 929864185,
    },
    [37] = {
        coords = vec3(6.2821359634399, -677.07763671875, 15.220226287842),
        modelHash = -1685625437,
    },
    [38] = {
        coords = vec3(7.5698385238647, -677.34100341797, 15.130056381226),
        modelHash = -2018598162,
    },
    [39] = {
        coords = vec3(7.7815361022949, -676.47741699219, 15.602298736572),
        modelHash = 929864185,
    },
    [40] = {
        coords = vec3(8.8905487060547, -676.73675537109, 15.602298736572),
        modelHash = 929864185,
    },
    [41] = {
        coords = vec3(9.3162937164307, -675.1201171875, 15.220423698425),
        modelHash = -1685625437,
    },
    [42] = {
        coords = vec3(9.7301445007324, -674.01861572266, 15.130056381226),
        modelHash = -2022916910,
    },
    [43] = {
        coords = vec3(6.9647393226624, -673.05187988281, 15.219604492188),
        modelHash = 307713837,
    },
    [44] = {
        coords = vec3(5.489725112915, -672.45397949219, 15.130056381226),
        modelHash = -2022916910,
    },

    -- Cage 5
    [45] = {
        coords = vec3(-1.7896595001221, -661.14086914062, 15.602298736572),
        modelHash = -1326042488,
    },
    [46] = {
        coords = vec3(-2.7442359924316, -660.72412109375, 15.132097244263),
        modelHash = -2022916910,
    },
    [47] = {
        coords = vec3(-0.67496681213379, -656.56811523438, 15.220226287842),
        modelHash = -1685625437,
    },
    [48] = {
        coords = vec3(0.58071994781494, -657.04211425781, 15.219604492188),
        modelHash = 307713837,
    },
    [49] = {
        coords = vec3(1.9007949829102, -657.33312988281, 15.602298736572),
        modelHash = -1326042488,
    },
    [50] = {
        coords = vec3(2.8146457672119, -657.8837890625, 15.602298736572),
        modelHash = -1326042488,
    },
    
    -- Cage 6
    [51] = {
        coords = vec3(9.8513336181641, -660.40606689453, 15.220226287842),
        modelHash = -1685625437,
    },
    [52] = {
        coords = vec3(10.905244827271, -661.34417724609, 15.602298736572),
        modelHash = -1326042488,
    },
    [53] = {
        coords = vec3(11.040008544922, -660.60040283203, 15.602298736572),
        modelHash = -1326042488,
    },
    [54] = {
        coords = vec3(12.116771697998, -661.30718994141, 15.132097244263),
        modelHash = -2022916910,
    },
    [55] = {
        coords = vec3(13.292119979858, -661.68524169922, 15.132097244263),
        modelHash = -2022916910,
    },
    [56] = {
        coords = vec3(12.630909919739, -662.67120361328, 15.60470199585),
        modelHash = -1326042488,
    },
    [57] = {
        coords = vec3(13.523837089539, -663.03277587891, 15.220226287842),
        modelHash = -1685625437,
    },
    [58] = {
        coords = vec3(13.094585418701, -664.03344726562, 15.220226287842),
        modelHash = -1685625437,
    },
    [59] = {
        coords = vec3(12.652680397034, -665.30755615234, 15.219604492188),
        modelHash = 307713837,
    },
}