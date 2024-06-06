QBCore = exports['qb-core']:GetCoreObject()


local weedFields = {
    vector3(2216.5, 5577.5, 53.40),
    vector3(2218.5, 5577.3, 53.40),
    vector3(2220.5, 5577.1, 53.40),
    vector3(2223.1, 5577.1, 53.40),
    vector3(2225.3, 5576.9, 53.40),
    vector3(2227.8, 5576.8, 53.40),
    vector3(2230.1, 5576.7, 53.40),
    vector3(2232.3, 5576.4, 53.40),
    vector3(2233.48, 5578.66, 53.40),
    vector3(2230.51, 5578.89, 53.40),
    vector3(2225.83, 5579.07, 53.40),
    vector3(2223.36, 5579.35, 53.40),
    vector3(2219.36, 5579.52, 53.40),
    vector3(2216.24, 5575.27, 53.40),
    vector3(2217.83, 5575.27, 53.40),
    vector3(2220.63, 5574.96, 53.40),
    vector3(2223.13, 5574.8, 53.40),
    vector3(2226.91, 5574.57, 53.40),
    vector3(2230.28, 5574.29, 53.40)
}

local islemekonumu = vector3(2196.81, 5594.33, 53.63)


for i=1, #weedFields do
    exports['qb-target']:AddBoxZone("WeedField"..i, weedFields[i], 1, 1, {
        name="WeedField"..i,
        heading=0,
        debugPoly=false,
        minZ=weedFields[i].z - 1,
        maxZ=weedFields[i].z + 1,
    }, {
        options = {
            {
                type = "client",
                event = "minik-illegals:tiskenevirtopla",
                icon = "fas fa-cannabis",
                label = "Kenevir Topla",
            },
        },
        distance = 2.5
    })
end

RegisterNetEvent('minik-illegals:tiskenevirtopla', function()
    QBCore.Functions.Progressbar("harvest_weed", "Kenevir Toplanıyor...", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "amb@world_human_gardener_plant@male@base",
        anim = "base",
        flags = 16,
    }, {}, {}, function() 
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        for _, fieldCoords in pairs(weedFields) do
            if #(coords - fieldCoords) < 2 then
                TriggerServerEvent('minik-illegals:toplamaislemi')
                break
            end
        end
    end, function() 
        QBCore.Functions.Notify("İşlem iptal edildi!", "error")
    end)
end)


exports['qb-target']:AddBoxZone("WeedProcessing", islemekonumu, 1, 1, {
    name="WeedProcessing",
    heading=0,
    debugPoly=false,
    minZ=islemekonumu.z - 1,
    maxZ=islemekonumu.z + 1,
}, {
    options = {
        {
            type = "client",
            event = "minik-illegals:tiskenevirisle",
            icon = "fas fa-cannabis",
            label = "Kenevir İşle",
        },
    },
    distance = 2.5
})

RegisterNetEvent('minik-illegals:tiskenevirisle', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    if #(coords - islemekonumu) < 2 then
        QBCore.Functions.Progressbar("process_weed", "Kenevir İşleniyor...", 10000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "amb@world_human_stand_fire@male@base",
            anim = "base",
            flags = 49,
        }, {}, {}, function() 
            TriggerServerEvent('minik-illegals:islemeislemi')
        end, function() 
            QBCore.Functions.Notify("İşlem iptal edildi!", "error")
        end)
    else
        QBCore.Functions.Notify("İşleme alanında değilsin!", "error")
    end
end)


TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Ped spawn etme
local pedInfo = {
    model = 'a_m_m_business_01',
    coords = vector4(2221.75, 5614.78, 54.9, 105.91),
    heading = 105.91
}

Citizen.CreateThread(function()
    local model = pedInfo.model
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    ped = CreatePed(1, model, pedInfo.coords.x, pedInfo.coords.y, pedInfo.coords.z, pedInfo.coords.w, false, true)
    SetPedHeading(ped, pedInfo.heading)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
end)



exports['qb-target']:AddTargetModel('a_m_m_business_01', {
    options = {
        {
            event = "qb-pedmenu:client:openMenu",
            icon = "fas fa-cannabis",
            label = "Joint Sat",
        }
    },
    distance = 2.5
})

-- Menüyü aç
RegisterNetEvent('qb-pedmenu:client:openMenu')
AddEventHandler('qb-pedmenu:client:openMenu', function()
    local dialog = exports['qb-input']:ShowInput({
        header = "Joint Satışı",
        submitText = "Satış Yap",
        inputs = {
            {
                text = "Satılacak Joint Miktarı", -- Text above the input
                name = "amount", -- Name of the input
                type = "number", -- The type of the input
                isRequired = true -- true or false (required or not)
            }
        }
    })
    if dialog then
        if not dialog.amount then return end
        TriggerServerEvent('qb-pedmenu:server:sellJoint', tonumber(dialog.amount))
    end
end)