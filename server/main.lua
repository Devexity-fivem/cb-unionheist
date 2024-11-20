local cameraBroken = {}
local cameras = Config.Cameras
local safeBlown = false
local blownUpDoors = {}

RegisterNetEvent('cb-unionheist:server:BrokeCamera', function(camera)
    cameraBroken[camera] = true
end)

RegisterNetEvent('cb-unionheist:server:BlowSafeDoor', function()
    -- TODO: Distance Check
    safeBlown = true
    TriggerClientEvent('cb-unionheist:client:BlowSafeDoor', -1)
end)

RegisterNetEvent('cb-unionheist:server:BlowUpDoor', function(door)
    -- TODO: Distance Check
    safeBlown = true
    TriggerClientEvent('cb-unionheist:client:BlowUpDoor', -1)
end)

lib.callback.register('cb-unionheist:server:IsSafeBlown', function(source)
    return safeBlown
end)

lib.callback.register('cb-unionheist:server:IsSafeBlown', function(source, door)
    return blownUpDoors[door] or false
end)