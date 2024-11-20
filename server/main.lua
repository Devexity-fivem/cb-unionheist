local vaultBlown = false
local blownCageDoors = {}

RegisterNetEvent('cb-unionheist:server:BlowVaultDoor', function()
    -- TODO: Distance Check
    vaultBlown = true
    TriggerClientEvent('cb-unionheist:client:BlowVaultDoor', -1)
end)

RegisterNetEvent('cb-unionheist:server:BlowCageDoor', function(cage)
    -- TODO: Distance Check
    blownCageDoors[cage] = true
    print(blownCageDoors[cage])
    TriggerClientEvent('cb-unionheist:client:BlowCageDoor', -1, cage)
end)

lib.callback.register('cb-unionheist:server:IsVaultBlown', function(source)
    return vaultBlown
end)

lib.callback.register('cb-unionheist:server:IsCageBlown', function(source, cage)
    print(blownCageDoors[cage])
    return blownCageDoors[cage] or false
end)