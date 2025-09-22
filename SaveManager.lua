-- SaveManager.lua
local SaveManager = {}

local saveFile = "save_data.lua"

function SaveManager:save(data)
    local file = io.open(saveFile, "w")
    if file then
        file:write("return " .. require("serpent").block(data))
        file:close()
        return true
    end
    return false
end

function SaveManager:load()
    local file = io.open(saveFile, "r")
    if file then
        local content = file:read("*a")
        file:close()
        local chunk = load(content)
        if chunk then
            return chunk()
        end
    end
    return nil
end

return SaveManager
