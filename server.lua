local QBCore = exports['qb-core']:GetCoreObject()

-- Get Item
RegisterServerEvent('scuba-diving:server:GetItem', function() 
    local src = source
    local Player  = QBCore.Functions.GetPlayer(src)
    local quantity = math.random(1, 2)
	if (60 >= math.random(1, 100)) then
        if Player.Functions.AddItem("weaponspart", math.random(1,2)) then   
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["weaponspart"], 'add')
        else
            TriggerClientEvent('QBCore:Notify', src, 'Pockets Full..', 'error')
        end		
	else
        TriggerClientEvent('QBCore:Notify', src, 'You Broke the Screw Driver..', 'error')
    end
end)

