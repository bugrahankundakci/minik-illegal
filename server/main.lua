QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('minik-illegals:toplamaislemi')
AddEventHandler('minik-illegals:toplamaislemi', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem('islenmemis_ot', 1)
    TriggerClientEvent('QBCore:Notify', src, "Kenevir başarıyla toplandı!", "success")
end)

RegisterServerEvent('minik-illegals:islemeislemi')
AddEventHandler('minik-illegals:islemeislemi', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local minikotadeti = Player.Functions.GetItemByName('islenmemis_ot')

    if minikotadeti ~= nil and minikotadeti.amount >= 3 then
        if Player.Functions.RemoveItem('islenmemis_ot', 3) then
            Player.Functions.AddItem('joint', 1)
            TriggerClientEvent('QBCore:Notify', src, "Kenevir başarıyla işlendi ve joint hazır!", "success")
        else
            TriggerClientEvent('QBCore:Notify', src, "Bir hata oluştu!", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Yeterli Işlenmemiş Ot yok!", "error")
    end
end)

RegisterServerEvent('minik-illegals:sellJointToPed')
AddEventHandler('minik-illegals:sellJointToPed', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local pricePerJoint = 1000
    local payment = pricePerJoint * amount

    if Player.Functions.RemoveItem('joint', amount) then
        Player.Functions.AddMoney('cash', payment)
        TriggerClientEvent('QBCore:Notify', src, "Joint başarıyla satıldı ve $" .. payment .. " aldın!", "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "Yeterli joint yok!", "error")
    end
end)


-- Joint satışı
RegisterNetEvent('qb-pedmenu:server:sellJoint')
AddEventHandler('qb-pedmenu:server:sellJoint', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local pricePerJoint = 1000
    local amountToPay = pricePerJoint * amount

    if Player.Functions.RemoveItem('joint', amount) then
        Player.Functions.AddMoney('cash', amountToPay)
        TriggerClientEvent('QBCore:Notify', src, 'Satış başarılı! $' .. amountToPay .. ' kazandınız.', 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Yeterli jointiniz yok!', 'error')
    end
end)