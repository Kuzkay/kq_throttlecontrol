local maxRpm = Config.maxRpm
local maxSpeed = Config.maxSpeed

Citizen.CreateThread(function()
    while true do
        local sleep = 2000
        
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed) then
            local veh = GetVehiclePedIsIn(playerPed)
            
            -- Whether or not the ped is the driver
            if GetPedInVehicleSeat(veh, -1) == playerPed then
                sleep = 50
                local input = Config.keybinds.slow.input

                if IsControlPressed(0, input) and math.abs(GetVehicleThrottleOffset(veh)) > 0.3 and GetEntitySpeed(veh) * 3.6 <= maxSpeed then
                    sleep = 1

                    local rpm = GetVehicleCurrentRpm(veh)

                    if rpm > maxRpm then
                        SetVehicleCurrentRpm(veh, maxRpm)
                    end
                end
            end
        end
        
        Citizen.Wait(sleep)
    end
end)
