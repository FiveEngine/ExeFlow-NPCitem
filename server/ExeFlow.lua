QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('ExeFlow-npcitem:giveItems')
AddEventHandler('ExeFlow-npcitem:giveItems', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local steamHex = GetPlayerIdentifier(src, 0)
    local discordId = GetPlayerIdentifiers(src)[2]

    for itemName, amount in pairs(ExeFlow.ItemList) do
        Player.Functions.AddItem(itemName, amount)
        Wait(500)
    end

    TriggerClientEvent('QBCore:Notify', src, 'ExeFlow\'dan itemler aldın artık savaşa hazırsın.', 'success')
    
    local message = string.format("\n\nOyuncu **%s** (%s)\n\nSteam HEX: %s\n\nLicense ID: %s\n\nNPC'den aşağıdaki itemleri aldı:", GetPlayerName(src), src, steamHex, discordId)
    for itemName, amount in pairs(ExeFlow.ItemList) do
        message = message .. string.format("\n- %s x%d", itemName, amount)
    end

    sendToDiscord(ExeFlow.Webhook, "ExeFlow-npcitem", message, 3066993)
end)

function sendToDiscord(webhook, title, message, color)
    local embeds = {
        {
            ["title"] = title,
            ["description"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
                ["text"] = "ExeFlow İtem Alma"
            }
        }
    }

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({embeds = embeds}), {['Content-Type'] = 'application/json'})
end

