local createdLoot = {}
local robbedLoot = {}
local CreatedObjectHandles = {}

function DeleteNativeProps()
    for k, v in pairs(Config.DeleteProps) do
        local object = GetClosestObjectOfType(v.coords.x, v.coords.y, v.coords.z, 2, v.modelHash, false, false, false)
        CreateModelHide(v.coords.x, v.coords.y, v.coords.z, 0.05, v.modelHash, false)
    end
end

local function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText("STRING")
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(x,y,z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function SpawnMissionPeds()
    for k,v in pairs(Config.Guards) do
        local pedCoords = v.coords -- Replace with your desired coordinates
        local pedModel = GetHashKey(v.model) -- Replace with your desired ped model
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Wait(1)
        end
        local ped = CreatePed(4, pedModel, pedCoords.x, pedCoords.y, pedCoords.z, pedCoords.w, true, false)
        GiveWeaponToPed(ped, GetHashKey("WEAPON_CARBINERIFLE"), 100, false, true)
        local player = PlayerPedId()
        TaskCombatPed(ped, player, 0, 16)
        SetPedAccuracy(ped, 75)
        SetPedRelationshipGroupHash(ped, GetHashKey("HATES_PLAYER"))
        SetEntityAsMissionEntity(ped, true, true)
        SetPedCombatMovement(ped, 2)
        SetEntityHealth(ped, v.health)
        SetModelAsNoLongerNeeded(pedModel)
        exports.ox_target:addLocalEntity(ped, {
            label = "Rob",
            icon = "fa-solid fa-mask",
            distance = 1.5,
            canInteract = function(entity, distance, coords, name, bone)
                return IsEntityDead(entity)
            end,
            onSelect = function()
                print("TODO: Rob Guard")
                DeleteEntity(ped)
            end,
        })
    end
end

function BlowVaultDoor()
    if LocalPlayer.state.UnionHeist then
        local vaultCoords = Config.Vault.coords
        RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
        RequestModel("hei_p_m_bag_var22_arm_s")
        RequestNamedPtfxAsset("scr_ornate_heist")
        while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
            Wait(50)
        end
        local ped = PlayerPedId()
        SetEntityHeading(ped, 297)
        Wait(100)

        local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
        local bagscene = NetworkCreateSynchronisedScene(vaultCoords.x-1.75, vaultCoords.y, vaultCoords.z-0.5, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
        local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), vaultCoords.x-1.75, vaultCoords.y, vaultCoords.z-0.5, true, true, false)
        NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.2, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        NetworkStartSynchronisedScene(bagscene)
        Wait(3500)
        DeleteObject(bag)
        SetPedComponentVariation(ped, 5, 45, 0, 0)
        NetworkStopSynchronisedScene(bagscene)
        --AddExplosion(vaultCoords.x-1.75, vaultCoords.y+0.8, vaultCoords.z, 22, 0.8, true, false, 1)
        TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, false, false, false)
        TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, false, false, false)
        -- Add Evidence
        --Wait(52000)
        --AddExplosion(vaultCoords.x-1.75, vaultCoords.y, vaultCoords.z, 2, 0.8, true, false, 1)
        TriggerServerEvent('cb-unionheist:server:BlowVaultDoor')
        SpawnMissionPeds()
        Wait(5000)
        ClearPedTasks(ped)
    else
        Notify("Headaches", "You need to exit the depository and re-enter!", "error")
    end
end

function BlowCageDoor(cage)
    if LocalPlayer.state.UnionHeist then
        local cageCoords = Config.DoorLocations[cage].coords
        local pedHeading = Config.DoorLocations[cage].pedHeading
        RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
        RequestModel("hei_p_m_bag_var22_arm_s")
        RequestNamedPtfxAsset("scr_ornate_heist")
        while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
            Wait(50)
        end
        local ped = PlayerPedId()
        SetEntityHeading(ped, pedHeading)
        Wait(100)

        local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
        local targetModifier = Config.DoorLocations[cage].targetModifier
        local lootscene = NetworkCreateSynchronisedScene(cageCoords.x+targetModifier.x, cageCoords.y+targetModifier.y, cageCoords.z+targetModifier.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)

        NetworkAddPedToSynchronisedScene(ped, lootscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.2, -4.0, 1, 16, 1148846080, 0)
        SetPedComponentVariation(ped, 5, 45, 0, 0)
        NetworkStartSynchronisedScene(lootscene)
        Wait(3500)
        NetworkStopSynchronisedScene(lootscene)
        local explosionYModifier = Config.DoorLocations[cage].explosionYModifier
        local explosionXModifier = Config.DoorLocations[cage].explosionXModifier
        TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, false, false, false)
        TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, false, false, false)
        -- Add Evidence
        AddExplosion(cageCoords.x+explosionXModifier, cageCoords.y+explosionYModifier, cageCoords.z, 22, 0.8, true, false, 1)
        Wait(52000) --TODO: Change to 52000
        TriggerServerEvent('cb-unionheist:server:BlowCageDoor', cage)
        if Config.GasGrenades.enabled then
            for k, v in pairs(Config.GasGrenades.locations) do
                local gasCoords = v.coords
                AddExplosion(gasCoords.x, gasCoords.y, gasCoords.z, 21, 1.5, true, false, 1)
            end
        end
        AddExplosion(cageCoords.x+explosionXModifier, cageCoords.y+explosionYModifier, cageCoords.z, 43, 0.8, true, false, 1)
        ClearPedTasks(ped)
    else
        Notify("Headaches", "You need to exit the depository and re-enter!", "error")
    end
end

TeleportInside = lib.zones.box({
    coords = vector3(Config.TeleportIn.x, Config.TeleportIn.y, Config.TeleportIn.z), -- The center of the zone
    size = vec3(2, 1, 1),
    rotation = Config.TeleportIn.w, -- Rotation of the zone
    debug = true, -- Debug mode, set to true to visualize the zone
    inside = function()
        DrawText3Ds(Config.TeleportIn.x, Config.TeleportIn.y, Config.TeleportIn.z, "[E] Exit Depository")
        if IsControlJustReleased(0, 38) then -- 38 is the control for "E"
            DoScreenFadeOut(500)
            Wait(1000)
            SetEntityCoords(PlayerPedId(), Config.TeleportOut.x, Config.TeleportOut.y, Config.TeleportOut.z, false, false, false, false)
            SetEntityHeading(PlayerPedId(), Config.TeleportOut.w)
            SetGameplayCamRelativeHeading(Config.TeleportOut.w)
            DestroyVaultDoor()
            LocalPlayer.state.UnionHeist = false
            DoScreenFadeIn(500)
        end
    end
})

TeleportOutside = lib.zones.box({
    coords = vector3(Config.TeleportOut.x, Config.TeleportOut.y, Config.TeleportOut.z), -- The center of the zone
    size = vec3(2, 1, 1),
    rotation = Config.TeleportOut.w, -- Rotation of the zone
    debug = true, -- Debug mode, set to true to visualize the zone
    inside = function()
        DrawText3Ds(Config.TeleportOut.x, Config.TeleportOut.y, Config.TeleportOut.z, "[E] Enter Depository")
        if IsControlJustReleased(0, 38) then -- 38 is the control for "E"
            DoScreenFadeOut(500)
            Wait(1000)
            LocalPlayer.state.UnionHeist = true
            SetEntityCoords(PlayerPedId(), Config.TeleportIn.x, Config.TeleportIn.y, Config.TeleportIn.z, false, false, false, false)
            SetEntityHeading(PlayerPedId(), Config.TeleportIn.w)
            SetGameplayCamRelativeHeading(Config.TeleportIn.w)
            CreateVaultDoor()
            CreateCageDoors()
            CreateLoot()
            DoScreenFadeIn(500)
        end
    end
})

for k, v in pairs(Config.HackLocations) do
    exports.ox_target:addBoxZone({
        name = "UnionHeist_SecurityHack"..k,
        coords = Config.HackLocations[k].coords,
        size = Config.HackLocations[k].size,
        rotation = Config.HackLocations[k].coords.w,
        debug = Config.HackLocations[k].debug,
        options = {
            {
                icon = "fa-solid fa-mobile",
                label = 'Hack Vault Security '..k,
                onSelect = function()
                    TriggerServerEvent('cb-unionheist:server:SecurityHack', k)
                end,
                canInteract = function()
                    return HasItemClient(Config.HackLocations[k].required.item, Config.HackLocations[k].required.amount)
                end,
                distance = 2.5,
            }
        }
    })
end

function CreateVaultDoor()
    local vaultCoords = Config.Vault.coords
    local entity = GetClosestObjectOfType(vaultCoords.x, vaultCoords.y, vaultCoords.z, 2, -1932297301, false, false, false)
    local vaultBlown = lib.callback.await('cb-unionheist:server:IsVaultBlown', false)
    if not vaultBlown then
        FreezeEntityPosition(entity, true)
        exports.ox_target:addBoxZone({
            name = "UnionHeist_VaultDoor",
            coords = vec3(vaultCoords.x-1.75, vaultCoords.y, vaultCoords.z),
            size = Config.Vault.size,
            rotation = Config.Vault.coords.w,
            debug = Config.Vault.debug,
            options = {
                {
                    icon = "fa-solid fa-mobile",
                    label = 'Blow Vault Door',
                    onSelect = function()
                        BlowVaultDoor()
                        --[[
                        local securityHacked = lib.callback.await('cb-unionheist:server:IsSecurityHacked', false)
                        if securityHacked then
                            BlowVaultDoor()
                        else
                            Notify("Vault Security", "Take out the security system first!", "error")
                        end
                        ]]
                    end,
                    canInteract = function()
                        return true -- TODO: require item
                    end,
                    distance = 2.5,
                }
            }
        })
    end
end

function CreateCageDoors()
    for k, v in pairs(Config.DoorLocations) do
        local doorCoords = Config.DoorLocations[k].coords
        local entity = GetClosestObjectOfType(doorCoords.x, doorCoords.y, doorCoords.z, 0.05, Config.DoorLocations[k].modelHash, false, false, false)
        FreezeEntityPosition(entity, true)
        local targetModifier = Config.DoorLocations[k].targetModifier
        exports.ox_target:addBoxZone({
            name = "UnionHeist_Door_"..k,
            coords = vec3(doorCoords.x+targetModifier.x, doorCoords.y+targetModifier.y, doorCoords.z+targetModifier.z),
            size = Config.DoorLocations[k].size,
            rotation = Config.DoorLocations[k].coords.w,
            debug = Config.DoorLocations[k].debug,
            options = {
                {
                    icon = "fa-solid fa-explosion",
                    -- TODO: Fix all icons
                    label = 'Blow Cage Door '..k,
                    onSelect = function()
                        BlowCageDoor(k)
                    end,
                    canInteract = function()
                        --TODO: Item Check Here
                        return true
                    end,
                    distance = 2.5,
                }
            }
        })
    end
end

function CreateLoot()
    local lootData = lib.callback.await('cb-unionheist:server:GetLoot', false)

    if not lootData or next(lootData) == nil then
        return
    end
    for key, loot in pairs(lootData) do
        if loot.model then -- Ensure the loot has a model

            local goodModel = true
            for _, emptyModel in ipairs(Config.EmptyModels) do
                if loot.model == emptyModel then
                    goodModel = false
                    break
                end
            end
            -- Locate the matching Config.Loot entry for this key
            local lootConfig = Config.Loot[key]
            if lootConfig then
                -- Find the matching modelData within the lootConfig
                local modelData = nil
                for _, data in ipairs(lootConfig.models) do
                    if data.model == loot.model then
                        modelData = data
                        break
                    end
                end

                if modelData then
                    local modelHash = GetHashKey(loot.model)
                    local object = CreateObject(modelHash, lootConfig.coords.x, lootConfig.coords.y, lootConfig.coords.z, false, false, false)
                    SetEntityRotation(object, 0, 0, lootConfig.coords.w, 2, true)
                    FreezeEntityPosition(object, true)
                    if goodModel then
                        exports.ox_target:addBoxZone({
                            name = "UnionHeist_Loot_" .. key,
                            coords = vec3(lootConfig.coords.x, lootConfig.coords.y, lootConfig.coords.z),
                            size = vec3(lootConfig.size.x, lootConfig.size.y, lootConfig.size.z),
                            rotation = lootConfig.coords.w,
                            debug = false,
                            options = {
                                {
                                    icon = "fa-solid fa-mask",
                                    label = 'Loot',
                                    onSelect = function()
                                        StealLoot(key, modelHash, lootConfig.coords)
                                    end,
                                    canInteract = function()
                                        return true
                                    end,
                                    distance = 1,
                                }
                            }
                        })
                    end

                    -- Track the created loot object
                    createdLoot[key] = object
                end
            end
        end
    end
end

RegisterNetEvent('cb-unionheist:client:BlowVaultDoor', function()
    if LocalPlayer.state.UnionHeist then
        local vaultBlown = lib.callback.await('cb-unionheist:server:IsVaultBlown', false)
        if not vaultBlown then
            return
        else
            local vaultCoords = Config.Vault.coords
            local entity = GetClosestObjectOfType(vaultCoords.x, vaultCoords.y, vaultCoords.z, 2, -1932297301, false, false, false)
            FreezeEntityPosition(entity, false)
        end
    end
end)

RegisterNetEvent('cb-unionheist:client:BlowCageDoor', function(cage)
    if LocalPlayer.state.UnionHeist then
        -- TODO: Check if Vault Blown too
        local cageCoords = Config.DoorLocations[cage].coords
        local entity = GetClosestObjectOfType(cageCoords.x, cageCoords.y, cageCoords.z, 0.05, Config.DoorLocations[cage].modelHash, false, false, false)
        FreezeEntityPosition(entity, false)
        --[[
            local cageCoords = Config.DoorLocations[cage].coords
            CreateModelHide(cageCoords.x, cageCoords.y, cageCoords.z, 0.01, Config.DoorLocations[cage].modelHash, true)
        ]]
    end
end)

RegisterNetEvent('cb-unionheist:client:SyncLoot', function(lootKey, model)
    print("[DEBUG] SyncLoot triggered")
    print("[DEBUG] Loot Key:", lootKey, "Model:", model)
    
    -- Mark this loot as robbed
    robbedLoot[lootKey] = true
    print("[DEBUG] Marked loot as robbed:", lootKey)

    if LocalPlayer.state.UnionHeist then
        -- Ensure vault is blown, if applicable
        print("[DEBUG] Union Heist active, processing loot.")
        
        local lootCoords = Config.Loot[lootKey].coords
        print("[DEBUG] Loot Coordinates:", lootCoords)

        -- Debug potential object search
        -- Uncomment if needed for debugging
        --local object = GetClosestObjectOfType(lootCoords.x, lootCoords.y, lootCoords.z, 0.05, GetHashKey(model), false, false, false)
        --print("[DEBUG] Closest object:", object)

        local newModel
        local modelFound = false -- Flag to check if the model was found in the loop
        
        -- Iterate through models in the config
        for k, v in pairs(Config.Loot[lootKey].models) do
            print("[DEBUG] Checking model:", v.model, "against given model:", model)
            if v.model == model then
                modelFound = true
                newModel = v.newModel
                print("[DEBUG] Matching model found. New Model:", newModel)

                -- Swap models
                CreateModelSwap(lootCoords.x, lootCoords.y, lootCoords.z, 0.05, GetHashKey(model), GetHashKey(newModel), false)
                print("[DEBUG] Model swap executed: From", model, "to", newModel)

                -- Remove zone targeting
                local zoneId = "UnionHeist_Loot_"..lootKey
                print("[DEBUG] Removing zone target:", zoneId)
                exports.ox_target:removeZone(zoneId)
                break
            end
        end
        
        if not modelFound then
            print("[DEBUG] No matching model found for:", model, "in lootKey:", lootKey)
        end
    else
        print("[DEBUG] Union Heist is not active. SyncLoot aborted.")
    end
end)

function DestroyLoot()
    for k, object in pairs(createdLoot) do
        if DoesEntityExist(object) then
            DeleteObject(object) -- Deletes the object
            exports.ox_target:removeZone("UnionHeist_Loot_"..k)
        end
    end
    createdLoot = {}
end

function DestroyVaultDoor()
    exports.ox_target:removeZone("UnionHeist_VaultDoor")
end

function DestroyCageDoors()
    for k, v in pairs(Config.DoorLocations) do
        exports.ox_target:removeZone("UnionHeist_Door_"..k)
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for k, object in pairs(createdLoot) do
            if DoesEntityExist(object) then
                DeleteObject(object) -- Deletes the object
                exports.ox_target:removeZone("UnionHeist_Loot_"..k)
            end
        end

        -- Clear the table after deleting
        createdLoot = {}
    end
end)

function StealLoot(key, modelHash, coords)
    if lib.progressBar({
        duration = 1000, -- TODO: Bring this to the config.lua file
        label = "Looting",
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'anim@heists@ornate_bank@grab_cash',
            clip = 'grab'
        },
    }) then
        TriggerServerEvent('cb-unionheist:server:LootStolen', key)
    else
        Notify("Art Heist", "You cancelled the action", "error")
    end
end

function UpdateExtraCageDoors()
    -- Check if the UnionHeist state is active
    if LocalPlayer.state.UnionHeist then
        -- Create objects and add them to the array
        for _, v in pairs(Config.CreatedProps) do
            local object = CreateObject(v.modelHash, v.coords.x, v.coords.y, v.coords.z, false, false, false)
            SetEntityHeading(object, v.coords.w)
            FreezeEntityPosition(object, true)
            table.insert(CreatedObjectHandles, object)
        end
    else
        -- Delete all objects stored in the array
        for _, object in pairs(CreatedObjectHandles) do
            if DoesEntityExist(object) then
                DeleteObject(object)
            end
        end
        -- Clear the array after deletion
        CreatedObjectHandles = {}

        -- Optionally hide the models
        for _, v in pairs(Config.CreatedProps) do
            CreateModelHide(v.coords.x, v.coords.y, v.coords.z, 1, v.modelHash, false)
        end
    end
end


-- TODO: Make sure everything works without the below code
RegisterCommand("enterHeist", function()
    LocalPlayer.state.UnionHeist = true
    DeleteNativeProps()
    UpdateExtraCageDoors()
    CreateVaultDoor()
    CreateCageDoors()
    CreateLoot()
end, false)

RegisterCommand("exitHeist", function()
    LocalPlayer.state.UnionHeist = false
    UpdateExtraCageDoors()
    DestroyVaultDoor()
    DestroyCageDoors()
    DestroyLoot()
end, false)

RegisterCommand("blowvault", function()
    TriggerServerEvent('cb-unionheist:server:BlowVaultDoor')
end, false)
--[[
My attempt at a synchronized scene for stealing trolly loot. Didn't really work.
TODO: Refactor this code at a later date

--- Creates a networked scene for stealing loot from a trolley during a heist.
--- @param key integer The key of the loot being stolen
--- @param modelHash integer Model Hash
--- @param coords vector3 Coordinates of the trolley
function StealLoot(key, modelHash, coords)
    local ped = PlayerPedId()
    -- Load required model
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(0)
    end
    -- Create object
    local trolley = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1, modelHash, false, false, false)
    SetModelAsNoLongerNeeded(modelHash)

    -- Load animation dictionary
    local animDict = "anim@heists@ornate_bank@grab_cash"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(0)
    end

    -- Create networked scene
    local scene = NetworkCreateSynchronisedScene(coords.x, coords.y, coords.z+0.5, 0.0, 0.0, 0.0, 2, true, false, 1.0, 0, 1.0)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, animDict, "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(trolley, scene, animDict, "cart_cash_dissapear", 4.0, -8.0, 1)

    -- Start scene
    NetworkStartSynchronisedScene(scene)

    -- Wait for animation to finish
    Wait(5000)

    -- Delete trolley object
    DeleteObject(trolley)

    -- Cleanup
    RemoveAnimDict(animDict)
    ClearPedTasks(ped)
end
]]