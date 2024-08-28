local maxRpm = Config.maxRpm
local maxSpeed = Config.maxSpeed
local throttleControlEnabled = Config.defaultSmoothing  -- Set based on defaultSmoothing
local allowedClasses = Config.allowedClasses

local function TriggerThrottleControl()
    if not throttleControlEnabled then
        return
    end
    
    CreateThread(function()
        while throttleControlEnabled do
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local sleepDuration = 50
            if vehicle and DoesEntityExist(vehicle) then
                local vehicleClass = GetVehicleClass(vehicle)
                if allowedClasses[vehicleClass] then
                    local vehicleSpeed = GetEntitySpeed(vehicle) * 3.6
                    local throttleOffset = math.abs(GetVehicleThrottleOffset(vehicle))
                    if throttleOffset > 0.3 and vehicleSpeed <= maxSpeed then
                        sleepDuration = 1
                        local currentRpm = GetVehicleCurrentRpm(vehicle)
                        if currentRpm > maxRpm then
                            SetVehicleCurrentRpm(vehicle, maxRpm)
                        end
                    end
                end
            end
            Wait(sleepDuration)
        end
    end)
end

RegisterCommand('+throttlecontrol', function()
    throttleControlEnabled = not Config.defaultSmoothing
    TriggerThrottleControl()
end, false)

RegisterCommand('-throttlecontrol', function()
    throttleControlEnabled = Config.defaultSmoothing
    TriggerThrottleControl()
end, false)


RegisterKeyMapping('+throttlecontrol', 'Disable/Enable throttle control while holding depending on config', 'keyboard', Config.keybinds.slow.input)
