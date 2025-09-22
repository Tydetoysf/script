-- ThemeManager.lua
local ThemeManager = {}

ThemeManager.themes = {
    default = {
        background = "#222222",
        foreground = "#ffffff",
        accent = "#0078d7"
    },
    light = {
        background = "#ffffff",
        foreground = "#222222",
        accent = "#ff9800"
    }
}

ThemeManager.current = ThemeManager.themes.default

function ThemeManager:setTheme(name)
    if self.themes[name] then
        self.current = self.themes[name]
        return true
    end
    return false
end

function ThemeManager:getTheme()
    return self.current
end

return ThemeManager
