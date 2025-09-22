-- Library.lua
local Library = {}

function Library:tableLength(tbl)
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end

function Library:deepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Library:deepCopy(orig_key)] = Library:deepCopy(orig_value)
        end
        setmetatable(copy, Library:deepCopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

return Library
