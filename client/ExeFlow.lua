local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    local npc = ExeFlow.NPC
    RequestModel(GetHashKey(npc.model))
    while not HasModelLoaded(GetHashKey(npc.model)) do
        Wait(1)
    end

    local npcPed = CreatePed(4, npc.model, npc.coords.x, npc.coords.y, npc.coords.z, npc.heading, false, true)
    FreezeEntityPosition(npcPed, true)
    SetEntityInvincible(npcPed, true)
    SetBlockingOfNonTemporaryEvents(npcPed, true)
end)

CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - ExeFlow.NPC.coords)
        if distance < ExeFlow.NPC.distance then
            DrawText3D(ExeFlow.NPC.coords.x, ExeFlow.NPC.coords.y, ExeFlow.NPC.coords.z + 1.0, "[E] Give İtem")
            if IsControlJustReleased(0, 38) then
                local ped = PlayerPedId()
                QBCore.Functions.Progressbar("unique_key", "İtem Alınıyor...", 5000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "mp_common",
                    anim = "givetake1_a",
                    flags = 8,
                }, {}, {}, function()
                    ClearPedTasks(ped)
                    TriggerServerEvent('ExeFlow-npcitem:giveItems')
                end, function()
                    ClearPedTasks(ped)
                    QBCore.Functions.Notify("İşlem iptal edildi.", "error")
                end)
            end
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y+0.0150, 0.015 + factor, 0.03, 41, 11, 41, 68)
end
