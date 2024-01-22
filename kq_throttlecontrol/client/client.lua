local maxRpm = Config.maxRpm
local maxSpeed = Config.maxSpeed
local enabled = false

local function TriggerThrottleControl()
    CreateThread(function()
        while enabled do
            local veh = GetVehiclePedIsIn(PlayerPedId())
            sleep = 50
            if math.abs(GetVehicleThrottleOffset(veh)) > 0.3 and GetEntitySpeed(veh) * 3.6 <= maxSpeed then
                sleep = 1

                local rpm = GetVehicleCurrentRpm(veh)

                if rpm > maxRpm then
                    SetVehicleCurrentRpm(veh, maxRpm)
                end
            end
            Wait(sleep)
        end
        print('rip loop')
    end)
end

RegisterCommand('+throttlecontrol', function()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed) then
        local veh = GetVehiclePedIsIn(playerPed)

        -- Whether or not the ped is the driver
        if GetPedInVehicleSeat(veh, -1) == playerPed then
            -- enables the throttle control loop and calls the function
            enabled = true
            TriggerThrottleControl()
            print('enabled')
        end
    end
end, false)

RegisterCommand('-throttlecontrol', function()
    -- disables the throttle control loop
    print('disabled')
    enabled = false
end, false)

RegisterKeyMapping('+throttlecontrol', 'Throttle Control', 'keyboard', Config.keybinds.slow.input)
