Config = {}
Config.TeleportIn = vec4(5.79, -709.24, 16.13, 341.16)
Config.TeleportOut = vec4(10.23, -667.79, 33.45, 184.71)
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
        size = vec3(1, 1, 2),
        pedHeading = 120,
        explosionYModifier = -1,
        debug = true,
    },
}