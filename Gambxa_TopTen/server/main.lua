-- by Gambxa87
-- https://github.com/Gambxa87

function sendToDiscord(message)
    local time = os.date("*t")

    local embed = {
        {
            ["color"] = Config.LogColour,
            ["author"] = {
                ["icon_url"] = Config.AvatarURL,
                ["name"] = Config.ServerName,
            },
            ["title"] = "**".. Config.LogTitle .." - Created by Gambxa87**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = '' ..time.year.. '/' ..time.month..'/'..time.day..' '.. time.hour.. ':'..time.min .. " | Powered by Gambxa87",
            },
        }
    }

    PerformHttpRequest(Config.WebHook, function(err, text, headers) end, 'POST', json.encode({username = "Gambxa87", embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Citizen.CreateThread(function()
    while (Config.SendLogByTime.enable) do
        TriggerEvent("toptentracker:server:sendLog")
        Citizen.Wait(Config.SendLogByTime.time * (60 * 1000))
    end
end)

ESX.RegisterCommand("topmoney", 'admin', function()
    if (Config.OnlyTopRichest.enable) then
        TriggerEvent("toptentracker:server:getTopPlayerMoney", Config.LogMessageType)
    else
        TriggerEvent("toptentracker:server:getAllPlayerMoney", Config.LogMessageType)
    end
end, true, {help = "Get the top richest players"})

RegisterNetEvent("toptentracker:server:getTopPlayerMoney", function(type)
    local topRichestPlayers
    local resultWithLicense = ''

    if Config.BlackMoney then
        topRichestPlayers = MySQL.Sync.fetchAll("SELECT `identifier`, `accounts`, CONCAT(`firstname`, ' ' ,`lastname`) AS `full_name`, JSON_VALUE(accounts, '$.money') + JSON_VALUE(accounts, '$.bank') + JSON_VALUE(accounts, '$.black_money') AS `total_money` FROM `users` GROUP BY `identifier` ORDER BY `total_money` DESC LIMIT ?", {Config.OnlyTopRichest.top})
    else
        topRichestPlayers = MySQL.Sync.fetchAll("SELECT `identifier`, `accounts`, CONCAT(`firstname`, ' ' ,`lastname`) AS `full_name`, JSON_VALUE(accounts, '$.money') + JSON_VALUE(accounts, '$.bank') AS `total_money` FROM `users` GROUP BY `identifier` ORDER BY `total_money` DESC LIMIT ?", {Config.OnlyTopRichest.top})
    end

    for _, v in pairs(topRichestPlayers) do
        resultWithLicense = resultWithLicense .. "```" .. topRichestPlayers[_]["full_name"] .. "\n".. topRichestPlayers[_]["identifier"] .. "\n".. topRichestPlayers[_]["accounts"].. "\nTotal Money: " .. topRichestPlayers[_]["total_money"] .. "```\n"
    end

    sendToDiscord(resultWithLicense .. "\n**Logged by Gambxa87**")
end)

RegisterNetEvent("toptentracker:server:getAllPlayerMoney", function(type)
    local topRichestPlayers
    local resultWithLicense = ''

    if Config.BlackMoney then
        topRichestPlayers = MySQL.Sync.fetchAll("SELECT `identifier`, `accounts`, CONCAT(`firstname`, ' ' ,`lastname`) AS `full_name`, JSON_VALUE(accounts, '$.money') + JSON_VALUE(accounts, '$.bank') + JSON_VALUE(accounts, '$.black_money') AS `total_money` FROM `users` GROUP BY `identifier` ORDER BY `total_money` DESC")
    else
        topRichestPlayers = MySQL.Sync.fetchAll("SELECT `identifier`, `accounts`, CONCAT(`firstname`, ' ' ,`lastname`) AS `full_name`, JSON_VALUE(accounts, '$.money') + JSON_VALUE(accounts, '$.bank') AS `total_money` FROM `users` GROUP BY `identifier` ORDER BY `total_money` DESC")
    end

    for _, v in pairs(topRichestPlayers) do
        resultWithLicense = resultWithLicense .. "```" .. topRichestPlayers[_]["full_name"] .. "\n".. topRichestPlayers[_]["identifier"] .. "\n".. topRichestPlayers[_]["accounts"].. "\nTotal Money: " .. topRichestPlayers[_]["total_money"] .. "```\n"
    end

    sendToDiscord(resultWithLicense .. "\n**Logged by Gambxa87**")
end)

RegisterNetEvent("toptentracker:server:sendLog", function()
    if (Config.OnlyTopRichest.enable) then
        TriggerEvent("toptentracker:server:getTopPlayerMoney", Config.LogMessageType)
    else
        TriggerEvent("toptentracker:server:getAllPlayerMoney", Config.LogMessageType)
    end
end)  

-- https://github.com/Gambxa87