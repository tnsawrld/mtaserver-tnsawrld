--function spawn vehicle/kendaraan
function SpawnVehicle(player, command, model)
    local x, y, z = getElementPosition(player)
    local y = y + 5
    
    createVehicle(model, x, y, z)
    outputChatBox('Anda berhasil spawn kendaraan!',player, 50, 255, 50)
end

addCommandHandler('veh', SpawnVehicle, false, false)