local createdLoot = {}

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
            Citizen.Wait(50)
        end
        local ped = PlayerPedId()
        SetEntityHeading(ped, 297)
        Citizen.Wait(100)

        local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
        local bagscene = NetworkCreateSynchronisedScene(vaultCoords.x-1.75, vaultCoords.y, vaultCoords.z-0.5, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
        local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), vaultCoords.x-1.75, vaultCoords.y, vaultCoords.z-0.5, true, true, false)
        NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.2, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        NetworkStartSynchronisedScene(bagscene)
        Citizen.Wait(3500)
        DeleteObject(bag)
        SetPedComponentVariation(ped, 5, 45, 0, 0)
        NetworkStopSynchronisedScene(bagscene)
        --AddExplosion(vaultCoords.x-1.75, vaultCoords.y+0.8, vaultCoords.z, 22, 0.8, true, false, 1)
        TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, false, false, false)
        TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, false, false, false)
        -- Add Evidence
        --Citizen.Wait(52000)
        --AddExplosion(vaultCoords.x-1.75, vaultCoords.y, vaultCoords.z, 2, 0.8, true, false, 1)
        TriggerServerEvent('cb-unionheist:server:BlowVaultDoor')
        SpawnMissionPeds()
        Citizen.Wait(5000)
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
            Citizen.Wait(50)
        end
        local ped = PlayerPedId()
        SetEntityHeading(ped, pedHeading)
        Citizen.Wait(100)

        local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
        local targetModifier = Config.DoorLocations[cage].targetModifier
        local bagscene = NetworkCreateSynchronisedScene(cageCoords.x+targetModifier.x, cageCoords.y+targetModifier.y, cageCoords.z+targetModifier.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)

        NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.2, -4.0, 1, 16, 1148846080, 0)
        SetPedComponentVariation(ped, 5, 45, 0, 0)
        NetworkStartSynchronisedScene(bagscene)
        Citizen.Wait(3500)
        NetworkStopSynchronisedScene(bagscene)
        local explosionYModifier = Config.DoorLocations[cage].explosionYModifier
        local explosionXModifier = Config.DoorLocations[cage].explosionXModifier
        TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, false, false, false)
        TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, false, false, false)
        -- Add Evidence
        --AddExplosion(cageCoords.x+explosionXModifier, cageCoords.y+explosionYModifier, cageCoords.z, 22, 0.8, true, false, 1)
        Citizen.Wait(5000) --TODO: Change to 52000
        TriggerServerEvent('cb-unionheist:server:BlowCageDoor', cage)
        --if Config.GasGrenades.enabled then
        --    for k, v in pairs(Config.GasGrenades.locations) do
        --        local gasCoords = v.coords
        --        AddExplosion(gasCoords.x, gasCoords.y, gasCoords.z, 21, 1.5, true, false, 1)
        --    end
        --end
        --AddExplosion(cageCoords.x+explosionXModifier, cageCoords.y+explosionYModifier, cageCoords.z, 43, 0.8, true, false, 1)
        Citizen.Wait(5000)
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
                label = 'Hack Vault Security',
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
                    end,
                    canInteract = function()
                        return HasItemClient(Config.Vault.required.item, Config.Vault.required.amount)
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
    for _, loot in pairs(lootData) do
        if loot.modelHash then -- Ensure a model is set
            local object = CreateObject(loot.modelHash, loot.coords.x, loot.coords.y, loot.coords.z, false, false, false)
            SetEntityRotation(object, 0, 0, loot.coords.w, 2, true)
            FreezeEntityPosition(object, true)
            exports.ox_target:addBoxZone({
                name = "UnionHeist_Loot_".._,
                coords = vec3(loot.coords.x, loot.coords.y, loot.coords.z),
                size = vec3(loot.size.x, loot.size.y, loot.size.z),
                rotation = loot.coords.w,
                debug = false,
                options = {
                    {
                        icon = "fa-solid fa-mask",
                        label = 'Loot',
                        onSelect = function()
                            print("TODO: Steal Loot")
                        end,
                        canInteract = function()
                            return true
                        end,
                        distance = 2.5,
                    }
                }
            })
            createdLoot[_] = object
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

-- TODO: Make sure everything works without the below code

RegisterCommand("enterHeist", function()
    LocalPlayer.state.UnionHeist = true
    DeleteNativeProps()
    CreateVaultDoor()
    CreateLoot()
end, false)

RegisterCommand("exitHeist", function()
    LocalPlayer.state.UnionHeist = false
    DestroyVaultDoor()
    DestroyLoot()
end, false)