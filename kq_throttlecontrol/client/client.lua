local maxRpm = Config.maxRpm
local maxSpeed = Config.maxSpeed
local ThrottleControlEnabled = Config.defaultsmoothing  -- Set based on defaultsmoothing
local allowedClasses = Config.allowedClasses

local function TriggerThrottleControl()
    CreateThread(function()
        while true do
            if ThrottleControlEnabled then
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
            else
                Wait(100)
            end
        end
    end)
end

RegisterCommand('+throttlecontrol', function()
    ThrottleControlEnabled = not Config.defaultsmoothing
end, false)

RegisterCommand('-throttlecontrol', function()
    ThrottleControlEnabled = Config.defaultsmoothing
end, false)

TriggerThrottleControl()

RegisterKeyMapping('+throttlecontrol', 'Disable/Enable throttle control while holding depending on config', 'keyboard', Config.keybinds.slow.input)
