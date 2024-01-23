Config = {}

--- Max RPM in percentage
Config.maxRpm = 0.2

--- Speed in KM/h
-- The throttle control will not affect the vehicles which drive over this speed
Config.maxSpeed = 80

-- https://docs.fivem.net/docs/game-references/controls/
-- Use the input index for the "input" value
Config.keybinds = {
    slow = {
        input = 'lshift',
    }
}
