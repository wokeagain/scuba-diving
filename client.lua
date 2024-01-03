local QBCore = exports['qb-core']:GetCoreObject()
local spawnedBox = 0
local weaponpartBox = {}

-- 
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(3051.569, -779.304, -12.193) 
	SetBlipSprite(blip, 597) 
	SetBlipDisplay(blip, 2)
	SetBlipScale(blip, 0.6)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 5)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Scuba Diving") 
    EndTextCommandSetBlipName(blip)
end)

-- 
RegisterNetEvent('scuba-diving:client:GetItem', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local nearbyObject, nearbyID
	for i=1, #weaponpartBox, 1 do
		if GetDistanceBetweenCoords(coords, GetEntityCoords(weaponpartBox[i]), false) < 2.5 then
			nearbyObject, nearbyID = weaponpartBox[i], i
		end
	end
	QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
		if HasItem then
			if nearbyObject and IsPedOnFoot(playerPed) then
				isPickingUp = true
                QBCore.Functions.Progressbar('name_here', 'Opening Box...', 5000, false, true, {
		    disableMovement = true,
		    disableCarMovement = true,
		    disableMouse = false,
		    disableCombat = true,
		}, {}, {}, {}, function()
				TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_PARKING_METER', 0, false)
				Wait(6500)
				ClearPedTasks(playerPed)
				Wait(1000)
				DeleteObject(nearbyObject) 
				table.remove(weaponpartBox, nearbyID)
				spawnedBox = spawnedBox - 1
				TriggerServerEvent('scuba-diving:server:GetItem')
			end)
			else
				QBCore.Functions.Notify('Too far way...', 'error', 3500)
			end
		else
			QBCore.Functions.Notify('You need a Screw Driver!', 'error', 3500)
		end
	end, "specialcutter")
end)

-- Get Cords
CreateThread(function()
	while true do
		Wait(10)
		local coords = GetEntityCoords(PlayerPedId())
		if GetDistanceBetweenCoords(coords, Config.ScubaField, true) < 50 then
			SpawnweaponpartBox()
			Wait(500)
		else
			Wait(500)
		end
	end
end)

-- Remove box
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(weaponpartBox) do
			DeleteObject(v)
		end
	end
end)

-- Spawn Box
function SpawnObject(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(1)
	end
    local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
    SetModelAsNoLongerNeeded(model)
    PlaceObjectOnGroundProperly(obj)
    FreezeEntityPosition(obj, true)
    if cb then
        cb(obj)
    end
end

-- 
function SpawnweaponpartBox()
	while spawnedBox < 15 do
		Wait(1)
		local boxCoords = GeneratePlantsCoords()
		SpawnObject('prop_tool_box_07', boxCoords, function(obj)
			table.insert(weaponpartBox, obj)
			spawnedBox = spawnedBox + 1
		end)
	end
end 

-- 
function ValidatePlantsCoord(boxCoord)
	if spawnedBox > 0 then
		local validate = true
		for k, v in pairs(weaponpartBox) do
			if GetDistanceBetweenCoords(boxCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end
		if GetDistanceBetweenCoords(boxCoord, Config.ScubaField, false) > 50 then
			validate = false
		end
		return validate
	else
		return true
	end
end

-- 
function GeneratePlantsCoords()
	while true do
		Wait(1)
		local boxCoordX, boxCoordY
		math.randomseed(GetGameTimer())
		local modX = math.random(-15, 15)
		Wait(100)
		math.randomseed(GetGameTimer())
		local modY = math.random(-15, 15)
		boxCoordX = Config.ScubaField.x + modX
		boxCoordY = Config.ScubaField.y + modY
		local coordZ = GetCoordZPlants(boxCoordX, boxCoordY)
		local coord = vector3(boxCoordX, boxCoordY, coordZ)
		if ValidatePlantsCoord(coord) then
			return coord
		end
	end
end

-- 
function GetCoordZPlants(x, y)
	local groundCheckHeights = { 35, 36.0, 37.0, 38.0, 39.0, 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0, 51.0, 52.0, 53.0, 54.0, 55.0 }
	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
		if foundGround then
			return z
		end
	end
	return 53.85
end

--
exports['qb-target']:AddTargetModel(`prop_tool_box_07`, {
    options = {
        {
            event = "scuba-diving:client:GetItem",
            icon = "fas fa-box",
            label = "Open Box",
        },
    },
    distance = 2.5
})

