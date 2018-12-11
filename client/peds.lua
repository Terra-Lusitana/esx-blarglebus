function createRandomPedInArea(x, y, z)
    local model = Config.PedModels[math.random(#Config.PedModels)]
    loadModel(model)

    x = x + math.random() * 4 - 2
    y = y + math.random() * 4 - 2
    local heading = math.random() * 360
    
    local ped = CreatePed(4, model, x, y, z, heading, true, false)
    FreezeEntityPosition(ped, true)
    return ped
end

function leaveVehicle(ped, vehicle)
    if IsPedDeadOrDying(ped) then
        RemovePedElegantly(ped)
    else
        ClearPedTasksImmediately(ped, true)
        TaskLeaveVehicle(ped, bus, 64)
    end
end

function enterVehicle(ped, vehicle, seatNumber)
    FreezeEntityPosition(ped, false)
    Citizen.Wait(10)
    TaskEnterVehicle(ped, 
        vehicle, 
        Config.EnterVehicleTimeout, -- timeout
        seatNumber,                 -- seat
        1.0,                        -- speed (walk)
        1,                          -- flag, normal
        0                           -- p6? lol
    )
end

function isPedInVehicleOrDead(ped, position)
    return GetVehiclePedIsIn(ped, false) or IsPedDeadOrDying(ped, 1)
end

function isPedInVehicleDeadOrTooFarAway(ped, position)
    if IsPedInAnyVehicle(ped, false) or IsPedDeadOrDying(ped, 1) then
        return true
    end

    return GetDistanceBetweenCoords(GetEntityCoords(ped), position.x, position.y, position.z) > 15
end

function loadModel(model)
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        RequestModel(GetHashKey(model))
        Citizen.Wait(10)
    end
end

Peds = {
    CreateRandomPedInArea = createRandomPedInArea,
    LeaveVehicle = leaveVehicle,
    EnterVehicle = enterVehicle,
    IsPedInVehicleOrDead = isPedInVehicleOrDead,
    IsPedInVehicleDeadOrTooFarAway = isPedInVehicleDeadOrTooFarAway
}