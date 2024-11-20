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
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), vaultCoords.x, vaultCoords.y, vaultCoords.z, true, true, false)

    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.2, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Citizen.Wait(1500)
    Citizen.Wait(2000)
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
end

function BlowCageDoor(cage)
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
    local bagscene = NetworkCreateSynchronisedScene(cageCoords.x, cageCoords.y, cageCoords.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), cageCoords.x, cageCoords.y, cageCoords.z, true, true, false)

    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.2, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Citizen.Wait(3500)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
    NetworkStopSynchronisedScene(bagscene)
    local explosionYModifier = Config.DoorLocations[cage].explosionYModifier
    AddExplosion(cageCoords.x, cageCoords.y-1, cageCoords.z, 22, 0.8, true, false, 1)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, false, false, false)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, false, false, false)
    -- Add Evidence
    --Citizen.Wait(52000)
    --AddExplosion(cageCoords.x-1.75, cageCoords.y, cageCoords.z, 2, 0.8, true, false, 1)
    TriggerServerEvent('cb-unionheist:server:BlowCageDoor')
    Citizen.Wait(5000)
    ClearPedTasks(ped)
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
            SetEntityCoords(PlayerPedId(), Config.TeleportIn.x, Config.TeleportIn.y, Config.TeleportIn.z, false, false, false, false)
            SetEntityHeading(PlayerPedId(), Config.TeleportIn.w)
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
    local hasSafeBeenBlown = lib.callback.await('cb-unionheist:server:IsSafeBlown', false)
    if not hasSafeBeenBlown then
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

function BlowVaultDoors()
    for k, v in pairs(Config.DoorLocations) do
        local doorCoords = Config.DoorLocations[k].coords
        local entity = GetClosestObjectOfType(doorCoords.x, doorCoords.y, doorCoords.z, 0.05, Config.DoorLocations[k].modelHash, false, false, false)
        FreezeEntityPosition(entity, true)
        exports.ox_target:addBoxZone({
            name = "UnionHeist_Door_"..k,
            coords = vec3(doorCoords.x, doorCoords.y, doorCoords.z),
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

RegisterNetEvent('cb-unionheist:client:BlowSafeDoor', function()
    local hasSafeBeenBlown = lib.callback.await('cb-unionheist:server:IsSafeBlown', false)
    if not hasSafeBeenBlown then
        return
    else
        local safeCoords = Config.SafeDoor.coords
        local entity = GetClosestObjectOfType(safeCoords.x, safeCoords.y, safeCoords.z, 2, -1932297301, false, false, false)
        FreezeEntityPosition(entity, false)
    end
end)

--RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    CreateVaultDoor()
    BlowVaultDoors()
--end)