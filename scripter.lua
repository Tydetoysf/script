repeat task.wait(0.1) until game:IsLoaded()

--- API CALLS

local Library = require(script.Library)
local ThemeManager = require(script.ThemeManager)
local SaveManager = require(script.SaveManager)

--- Script Variables

local Packets      = require(game.ReplicatedStorage.Modules.Packets)
local hungerSlider = game:GetService("Players").Shadowfriend687.PlayerGui.MainGui.Panels.Stats.Bars.Hunger.ValueLabel
local inventory    = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory.List
local skyPath      = game.ReplicatedStorage.Skies;
-- Added enhanced variables from Herkle Hub
local rs = game:GetService("ReplicatedStorage")
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local runs = game:GetService("RunService")
local tspmo = game:GetService("TweenService")

-- GUI


-- Example usage of ThemeManager
ThemeManager:setTheme('default')
local currentTheme = ThemeManager:getTheme()

-- Example usage of SaveManager
-- SaveManager:save({foo = "bar"})
-- local loadedData = SaveManager:load()

local Window = {
    Title = 'Neptune Rework',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.5,
    Theme = currentTheme
}

local function notify(text)
    Library:Notify(text)
end

local Tabs      = {
    -- Creates a new tab titled Main
    Main = Window:AddTab('Main'),
    Farm = Window:AddTab('Farm'),
    Visual = Window:AddTab('Visual'),
    Player = Window:AddTab('Player'), -- Added Player tab
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- Enhanced Kill Aura with multi-target support from Herkle Hub
local auraStuff = Tabs.Main:AddLeftGroupbox('Kill Aura') -- LEFT
auraStuff:AddDivider()

auraStuff:AddToggle('killAura', {
    Text = 'Kill Aura',
    Default = false, -- Default value (true / false)
})

auraStuff:AddSlider('auraRange', {
    Text = 'Range',
    Default = 8, -- NEED TO FIND THE MAXIMUM VALUE
    Min = 0,
    Max = 20,
    Rounding = 1,
    Compact = true,
    Suffix = " Studs ",
})

-- Added multi-target dropdown from Herkle Hub
auraStuff:AddDropdown('auraTargets', {
    Values = { '1', '2', '3', '4', '5', '6' },
    Default = 6, -- Changed from 1 to 6 for maximum targets
    Multi = false,
    Text = 'Max Targets',
})

-- Added swing cooldown from Herkle Hub
auraStuff:AddSlider('auraSwingCooldown', {
    Text = 'Attack Cooldown',
    Default = 0.1,
    Min = 0.01,
    Max = 1.01,
    Rounding = 2,
    Compact = true,
    Suffix = " s ",
})

auraStuff:AddDivider()

auraStuff:AddToggle('auraHitbox', {
    Text = 'Show Aura Hitbox',
    Default = false, -- Default value (true / false)
})

Toggles.killAura:AddKeyPicker('auraKeybind', {
    Default = 'R',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'Kill Aura Keybind ',
    NoUI = false,
})

-- Added Resource Aura from Herkle Hub
local resourceAuraStuff = Tabs.Main:AddLeftGroupbox('Resource Aura')
resourceAuraStuff:AddDivider()

resourceAuraStuff:AddToggle('resourceAura', {
    Text = 'Resource Aura',
    Default = false,
})

resourceAuraStuff:AddSlider('resourceAuraRange', {
    Text = 'Range',
    Default = 20,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Compact = true,
    Suffix = " Studs ",
})

resourceAuraStuff:AddDropdown('resourceTargets', {
    Values = { '1', '2', '3', '4', '5', '6' },
    Default = 6, -- Changed from 1 to 6 for maximum targets
    Multi = false,
    Text = 'Max Targets',
})

resourceAuraStuff:AddSlider('resourceSwingCooldown', {
    Text = 'Swing Cooldown',
    Default = 0.1,
    Min = 0.01,
    Max = 1.01,
    Rounding = 2,
    Compact = true,
    Suffix = " s ",
})

local pickupStuff = Tabs.Main:AddLeftGroupbox('Auto Pickup') -- LEFT
pickupStuff:AddDivider()

pickupStuff:AddToggle('autoPickUp', {
    Text = 'Auto Pickup',
    Default = false, -- Default value (true / false)
})

pickupStuff:AddSlider('pickupRange', {
    Text = 'Range',
    Default = 11, -- NEED TO FIND THE MAXIMUM VALUE
    Min = 8,
    Max = 35,
    Rounding = 1,
    Compact = true,
    Suffix = " Studs ",
})

pickupStuff:AddDivider()

pickupStuff:AddToggle('whitelist', {
    Text = 'Whitelist Items',
    Default = false, -- Default value (true / false)
    Tooltip = 'The only items it will pick up.',
})

-- Enhanced items list from Herkle Hub with more fruits
pickupStuff:AddDropdown('items', {
    Values = { 'Berry', 'Bloodfruit', 'Bluefruit', 'Lemon', 'Strawberry', 'Gold', 'Raw Gold', 'Crystal Chunk', 'Coin', 'Coins', 'Coin2', 'Coin Stack', 'Essence', 'Emerald', 'Raw Emerald', 'Pink Diamond', 'Raw Pink Diamond', 'Void Shard', 'Jelly', 'Magnetite', 'Raw Magnetite', 'Adurite', 'Raw Adurite', 'Ice Cube', 'Stone', 'Iron', 'Raw Iron', 'Steel', 'Hide', 'Leaves', 'Log', 'Wood', 'Pie', 'Crystal', 'Coal' },
    Default = 0,  -- number index of the value / string
    Multi = true, -- true / false, allows multiple choices to be selected
})

-- Replaced chest pickup with chest steal functionality
pickupStuff:AddToggle('chestSteal', {
    Text = 'Auto Chest Steal',
    Default = false,
})

Toggles.autoPickUp:AddKeyPicker('autoPickUpKeybind', {
    Default = 'E',   -- String as the name of the keybind (MB1, MB2 for mouse buttons)
    SyncToggleState = true,
    Mode = 'Toggle', -- Modes: Always, Toggle, Hold
    Text = 'Auto Pickup Keybind ',
    NoUI = false,    -- Set to true if you want to hide from the Keybind menu,
})

local healStuff = Tabs.Main:AddRightGroupbox('Auto Heal') -- LEFT
healStuff:AddDivider()

healStuff:AddToggle('autoHeal', {
    Text = 'Auto Heal',
    Default = false, -- Default value (true / false)
})

Toggles.autoHeal:AddKeyPicker('autoHealKeybind', {
    Default = 'F',   -- String as the name of the keybind (MB1, MB2 for mouse buttons)
    SyncToggleState = true,
    Mode = 'Toggle', -- Modes: Always, Toggle, Hold
    Text = 'Auto Heal Keybind ',
    NoUI = false,    -- Set to true if you want to hide from the Keybind menu,
})

-- Enhanced heal dropdown with more fruits from Herkle Hub
healStuff:AddDropdown('heals', {
    Values = { 'Berry', 'Bloodfruit', 'Bluefruit', 'Lemon', 'Strawberry', 'Coconut', 'Jelly', 'Banana', 'Orange', 'Oddberry', 'Strangefruit', 'Sunfruit', 'Pumpkin', 'Prickly Pear', 'Apple', 'Barley', 'Cloudberry', 'Carrot' },
    Default = 2,   -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected
})

healStuff:AddSlider('autoHealThresh', {
    Text = 'Auto Heal Threshold',
    Default = 80, -- NEED TO FIND THE MAXIMUM VALUE
    Min = 10,
    Max = 100,
    Rounding = 1,
    Compact = true,
    Suffix = " Hp ",
})

-- FARM

local mainFarmingStuff = Tabs.Farm:AddLeftGroupbox('Main Farming') -- LEFT
mainFarmingStuff:AddDivider()

mainFarmingStuff:AddToggle('autoMine', {
    Text = 'Auto Mine',
    Default = false, -- Default value (true / false)
})

mainFarmingStuff:AddToggle('autoGold', {
    Text = 'Auto Gold',
    Tooltip = 'Automatically detects and attacks Gold Nodes within range',
    Default = false, -- Default value (true / false)
})

mainFarmingStuff:AddSlider('autoGoldRange', {
    Text = 'Gold Detection Range',
    Default = 150,
    Min = 50,
    Max = 200,
    Rounding = 1,
    Compact = true,
    Suffix = " Studs",
})

mainFarmingStuff:AddToggle('prioritizeGold', {
    Text = 'Prioritize Gold Over Farming',
    Default = true,
    Tooltip = 'Stops other farming activities when gold is detected'
})

mainFarmingStuff:AddToggle('autoEat', {
    Text = 'Afk Eat',
    Default = false, -- Default value (true / false)
})

mainFarmingStuff:AddSlider('autoEatThresh', {
    Text = 'Auto Eat Threshold',
    Default = 50, -- NEED TO FIND THE MAXIMUM VALUE
    Min = 0,
    Max = 100,
    Rounding = 1,
    Compact = true,
    Suffix = " Hunger ",
})

mainFarmingStuff:AddInput('foodName', {
    Numeric = false,                 -- true / false, only allows numbers
    Finished = false,
    Text = 'Food',                   -- true / false, only calls callback when you press enter
    Placeholder = 'Ex: Cooked Meat', -- placeholder text when the box is empty
})

-- Added Critter Aura from Herkle Hub
local critterAuraStuff = Tabs.Farm:AddLeftGroupbox('Critter Aura')
critterAuraStuff:AddDivider()

critterAuraStuff:AddToggle('critterAura', {
    Text = 'Critter Aura',
    Default = false,
})

critterAuraStuff:AddSlider('critterAuraRange', {
    Text = 'Range',
    Default = 20,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Compact = true,
    Suffix = " Studs ",
})

critterAuraStuff:AddDropdown('critterTargets', {
    Values = { '1', '2', '3', '4', '5', '6' },
    Default = 6, -- Changed from 1 to 6 for maximum targets
    Multi = false,
    Text = 'Max Targets',
})

critterAuraStuff:AddSlider('critterSwingCooldown', {
    Text = 'Swing Cooldown',
    Default = 0.1,
    Min = 0.01,
    Max = 1.01,
    Rounding = 2,
    Compact = true,
    Suffix = " s ",
})

local antiAfk = mainFarmingStuff:AddButton({
    Text = 'Anti Afk',
    DoubleClick = false,
    Tooltip = "No AFK kick.",
    Func = function()
        print('You clicked a button!')
    end,
})

local miscFarmingStuff = Tabs.Farm:AddLeftGroupbox('Misc Farming') -- LEFT
miscFarmingStuff:AddDivider()

miscFarmingStuff:AddToggle('autoCoinPress', {
    Text = 'Auto Coin Press',
    Default = false, -- Default value (true / false)
    Tooltip = 'Nearest Coin Press'
})

miscFarmingStuff:AddToggle('autoRestock', {
    Text = 'Auto Fuel Campfire',
    Default = false, -- Default value (true / false)
    Tooltip = 'Nearest Campfire'
})

miscFarmingStuff:AddInput('fuelName', {
    Numeric = false,            -- true / false, only allows numbers
    Finished = false,
    Text = 'Fuel Name',         -- true / false, only calls callback when you press enter
    Placeholder = 'Ex: Leaves', -- placeholder text when the box is empty
})

-- Enhanced Planting section with functions from Herkle Hub
local plantingStuff = Tabs.Farm:AddRightGroupbox('Planting') -- RIGHT
plantingStuff:AddDivider()

-- Added Plant Box placement buttons from Herkle Hub
plantingStuff:AddButton({
    Text = 'Place 16x16 Plant Boxes',
    DoubleClick = false,
    Tooltip = 'Places 256 plant boxes in grid',
    Func = function()
        placestructure(16)
    end,
})

plantingStuff:AddButton({
    Text = 'Place 15x15 Plant Boxes',
    DoubleClick = false,
    Tooltip = 'Places 225 plant boxes in grid',
    Func = function()
        placestructure(15)
    end,
})

plantingStuff:AddButton({
    Text = 'Place 10x10 Plant Boxes',
    DoubleClick = false,
    Tooltip = 'Places 100 plant boxes in grid',
    Func = function()
        placestructure(10)
    end,
})

plantingStuff:AddButton({
    Text = 'Place 5x5 Plant Boxes',
    DoubleClick = false,
    Tooltip = 'Places 25 plant boxes in grid',
    Func = function()
        placestructure(5)
    end,
})

plantingStuff:AddToggle('autoCreatePlantBoxes', {
    Text = 'Create Plant Boxes',
    Default = false, -- Default value (true / false)
    Tooltip = 'Will place under player.',
})

plantingStuff:AddToggle('autoHarvest', {
    Text = 'Auto Harvest',
    Default = false, -- Default value (true / false)
})

plantingStuff:AddToggle('autoPlant', {
    Text = 'Auto Plant',
    Default = false, -- Default value (true / false)
})

-- Enhanced plant type dropdown with more fruits from Herkle Hub
plantingStuff:AddDropdown('plantType', {
    Values = { 'Bloodfruit', 'Bluefruit', 'Lemon', 'Coconut', 'Jelly', 'Banana', 'Orange', 'Oddberry', 'Berry', 'Strangefruit', 'Strawberry', 'Sunfruit', 'Pumpkin', 'Prickly Pear', 'Apple', 'Barley', 'Cloudberry', 'Carrot' },
    Default = 1,   -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected
    Callback = function(Value)
        print('[cb] Dropdown got changed. New value:', Value)
    end
})

-- Added farming tween functionality from Herkle Hub
plantingStuff:AddToggle('tweenToPlantBox', {
    Text = 'Tween to Plant Box',
    Default = false,
    Tooltip = 'Automatically move to empty plant boxes'
})

plantingStuff:AddToggle('tweenToBush', {
    Text = 'Tween to Bush + Plant Box',
    Default = false,
    Tooltip = 'Move to bushes first, then plant boxes'
})

plantingStuff:AddSlider('tweenRange', {
    Text = 'Tween Range',
    Default = 250,
    Min = 1,
    Max = 250,
    Rounding = 1,
    Compact = true,
    Suffix = " Studs ",
})

local miscFarmingStuff2 = Tabs.Farm:AddRightGroupbox('Misc Farming') -- RIGHT
miscFarmingStuff2:AddDivider()

miscFarmingStuff2:AddInput('itemName', {
    Numeric = false,           -- true / false, only allows numbers
    Finished = false,
    Text = 'Item Name',        -- true / false, only calls callback when you press enter
    Placeholder = 'Ex: Stone', -- placeholder text when the box is empty
})

miscFarmingStuff2:AddInput('numItems', {
    Numeric = true,           -- true / false, only allows numbers
    Finished = false,
    Text = 'Number Of Items', -- true / false, only calls callback when you press enter
    Placeholder = 'Ex: 20',   -- placeholder text when the box is empty
})

-- Enhanced drop items functionality from Herkle Hub
local dropItems = miscFarmingStuff2:AddButton({
    Text = 'Drop Items',
    DoubleClick = false,
    Func = function()
        local itemName = Options.itemName.Value
        local numItems = tonumber(Options.numItems.Value) or 1
        for i = 1, numItems do
            drop(itemName)
            task.wait(0.1)
        end
    end,
})

local dropAllItems = miscFarmingStuff2:AddButton({
    Text = 'Drop ALL Items',
    DoubleClick = true,
    Tooltip = 'Double click to drop all',
    Func = function()
        local inventory = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory:FindFirstChild("List")
        if not inventory then return end
        
        for _, child in ipairs(inventory:GetChildren()) do
            if child:IsA("ImageLabel") and child.Name ~= "" then
                if Packets and Packets.DropBagItem and Packets.DropBagItem.send then
                    Packets.DropBagItem.send(child.LayoutOrder)
                    task.wait(0.1)
                end
            end
        end
    end,
})

-- Added auto drop functionality from Herkle Hub
miscFarmingStuff2:AddToggle('autoDrop', {
    Text = 'Auto Drop',
    Default = false,
})

miscFarmingStuff2:AddDropdown('autoDropItem', {
    Values = { 'Bloodfruit', 'Jelly', 'Bluefruit', 'Log', 'Leaves', 'Wood', 'Stone', 'Iron' },
    Default = 1,
    Multi = false,
    Text = 'Auto Drop Item',
})

-- Added missing server utilities from original script
local serverStuff = Tabs['UI Settings']:AddRightGroupbox('Server Stuff') -- RIGHT
serverStuff:AddDivider()

local voidTP = serverStuff:AddButton({
    Text = 'Void teleport',
    DoubleClick = false,
    Func = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, -1000, 0)
    end,
})

local rejoin = serverStuff:AddButton({
    Text = 'Rejoin server',
    DoubleClick = false,
    Tooltip = "Won't work with private servers.",
    Func = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end,
})

local joinSmallServer = serverStuff:AddButton({
    Text = 'Join a small server',
    DoubleClick = false,
    Func = function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/"
        
        local _place = game.PlaceId
        local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
        
        function ListServers(cursor)
            local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
            return Http:JSONDecode(Raw)
        end
        
        local Server, Next; repeat
            local Servers = ListServers(cursor)
            Server = Servers.data[1]
            Next = Servers.nextPageCursor
        until Server
        
        TPS:TeleportToPlaceInstance(_place,Server.id,game.Players.LocalPlayer)
    end,
})

-- Added visual tab functions: lighting fix, no rain, and no lag
local visualStuff = Tabs.Visual:AddLeftGroupbox('Visual Settings')
visualStuff:AddDivider()

-- Fixed lighting fix toggle to include callback function
visualStuff:AddToggle('lightingFix', {
    Text = 'Lighting Fix',
    Default = false,
    Callback = function(value)
        _G.Lighting = value
        local gl = game.Lighting
        if _G.Lighting then
            gl.Brightness = 4
            gl.FogEnd = 1000000
            gl.GlobalShadows = false
            gl.TimeOfDay = 12
        else
            gl.Brightness = 2
            gl.GlobalShadows = true
            gl.TimeOfDay = 12
        end
    end
})

visualStuff:AddButton('noRain', {
    Text = 'No Rain',
    Func = function()
        for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
            if v:IsA("BasePart") and v.Name == "RainPart" then
                v:Destroy()
            end
        end
    end
})

visualStuff:AddButton('noLag', {
    Text = 'No Lag',
    Func = function()
        local Terrain = workspace:FindFirstChildOfClass('Terrain')
        local Lighting = game:GetService("Lighting")
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1000000
        for i,v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Explosion") then
                v.BlastPressure = 1
                v.BlastRadius = 1
            end
        end
        for i,v in pairs(Lighting:GetDescendants()) do
            if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                v.Enabled = false
            end
        end
        workspace.DescendantAdded:Connect(function(child)
            coroutine.wrap(function()
                if child:IsA('ForceField') then
                    runs.Heartbeat:Wait()
                    child:Destroy()
                elseif child:IsA('Sparkles') then
                    runs.Heartbeat:Wait()
                    child:Destroy()
                elseif child:IsA('Smoke') or child:IsA('Fire') then
                    runs.Heartbeat:Wait()
                    child:Destroy()
                end
            end)()
        end)
    end
})

-- Added Buildings Transparent toggle
visualStuff:AddToggle('buildingsTransparent', {
    Text = 'Buildings Transparent',
    Default = false,
    Callback = function(value)
        spawn(function()
            if value then
                for i, v in pairs(game.Workspace.Deployables:GetDescendants()) do
                    if v:IsA("Part") or v:IsA("BasePart") then
                        v.Transparency = 0.5
                    end
                end
            else
                for i, v in pairs(game.Workspace.Deployables:GetDescendants()) do
                    if v:IsA("Part") or v:IsA("BasePart") then
                        v.Transparency = 0
                    end
                end
            end
        end)
    end
})

-- Added Max Camera Distance slider
visualStuff:AddSlider('maxCameraDistance', {
    Text = 'Max Camera Distance',
    Default = 150,
    Min = 0.5,
    Max = 1500,
    Rounding = 100,
    Callback = function(value)
        game.Players.LocalPlayer.CameraMaxZoomDistance = value
    end
})

-- Added Camera No Clip button
visualStuff:AddButton('cameraNoclip', {
    Text = 'Camera No Clip',
    Func = function()
        local sc = (debug and debug.setconstant) or setconstant
        local gc = (debug and debug.getconstants) or getconstants
        local pop = game:GetService("Players").LocalPlayer.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper
        for _, v in pairs(getgc()) do
            if type(v) == 'function' and getfenv(v).script == pop then
                for i, v1 in pairs(gc(v)) do
                    if tonumber(v1) == .25 then
                        sc(v, i, 0)
                    elseif tonumber(v1) == 0 then
                        sc(v, i, .25)
                    end
                end
            end
        end
    end
})

-- Added ESP tab within Visual
local espStuff = Tabs.Visual:AddRightGroupbox('ESP Settings')
espStuff:AddDivider()

-- ESP functions
local function espOn()
    for i, v in pairs(game.Players:GetPlayers()) do
        if not v:FindFirstChildWhichIsA("BillboardGui") then
            if v ~= game.Players.LocalPlayer then
                local ap = Instance.new("BillboardGui", v)
                local ep = Instance.new("TextLabel", ap)
                local stat = Instance.new("TextLabel", ap)
                ap.Parent = v.Character.Head
                ap.Name = v.Name
                ap.ResetOnSpawn = false
                ap.AlwaysOnTop = true
                ap.LightInfluence = 0
                ap.Size = UDim2.new(0, 10, 0, 10)
                ep.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ep.Text = v.Name
                ep.Size = UDim2.new(0.0001, 0.00001, 0.0001, 0.00001)
                ep.BorderSizePixel = 4
                ep.BorderColor3 = Color3.new(255, 255, 255)
                ep.BorderSizePixel = 0
                ep.Font = "Code"
                ep.TextSize = 15
                ep.TextColor3 = Color3.fromRGB(255, 255, 255)
                ep.TextStrokeTransparency = 0
                ep.TextYAlignment = "Bottom"

                stat.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                stat.Text = "[HEALTH: " .. v.Character.Humanoid.Health .. "]"
                stat.Size = UDim2.new(0.0001, 0.00001, 0.0001, 0.00001)
                stat.BorderSizePixel = 4
                stat.BorderColor3 = Color3.new(255, 255, 255)
                stat.BorderSizePixel = 0
                stat.Font = "Code"
                stat.TextSize = 10
                stat.TextColor3 = Color3.fromRGB(255, 255, 255)
                stat.TextStrokeTransparency = 0
                stat.TextYAlignment = "Bottom"
            end
        end
    end
end

local function espOff()
    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer then
            for i, c in pairs(v.Character.Head:GetDescendants()) do
                if c.Name:find(v.Name) then
                    c:Destroy()
                end
            end
            wait(0.1)
        end
    end
end

espStuff:AddToggle('playerESP', {
    Text = 'Player ESP',
    Default = false,
    Callback = function(value)
        if value then
            espOn()
        else
            espOff()
        end
    end
})

-- Added Weather controls
local weather = {
    ["Shine"] = "Sunny",
    ["Doom"] = "Sunset",
    ["Snowy"] = "Snowy",
    ["Rain"] = "Stormy",
}

local function getCurrentWeather()
    for i, v in pairs(game.Lighting:GetChildren()) do
        if v:IsA("Sky") then
            return weather[v.Name], v
        end
    end
end

local function getWeather()
    local weatherTypes = {}
    for i, v in pairs(game.ReplicatedStorage.Skies:GetChildren()) do
        table.insert(weatherTypes, weather[v.Name])
    end
    return weatherTypes
end

visualStuff:AddDropdown('weather', {
    Text = 'Weather',
    Values = getWeather(),
    Default = getCurrentWeather(),
    Multi = false,
    Callback = function(option)
        local currentWeather, sky = getCurrentWeather()
        if option ~= currentWeather then
            for i, v in pairs(game.ReplicatedStorage.Skies:GetChildren()) do
                if weather[v.Name] == option then
                    sky:Destroy()
                    local newWeather = v:Clone()
                    newWeather.Parent = game.Lighting
                end
            end
        end
    end
})

-- Fixed Player tab content creation and organization
-- Added Player tab with speed controls and other functions
local playerStuff = Tabs.Player:AddLeftGroupbox('Player Settings')
playerStuff:AddDivider()

-- Walk Speed with loop function
local walkSpeedConnection = nil
playerStuff:AddSlider('walkSpeed', {
    Text = 'Walk Speed',
    Default = 16,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        if walkSpeedConnection then
            walkSpeedConnection:Disconnect()
        end
        walkSpeedConnection = loopWalkSpeed(game.Players.LocalPlayer, value)
    end
})

-- FOV Slider
playerStuff:AddSlider('FOV', {
    Text = 'FOV',
    Default = 70,
    Min = 70,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        game:GetService('Workspace').Camera.FieldOfView = value
    end
})

-- Max Slope Climber
playerStuff:AddSlider('slopeClimber', {
    Text = 'Max Slope Climber',
    Default = 50,
    Min = 46,
    Max = 89,
    Rounding = 1,
    Callback = function(value)
        if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") then
            game:GetService("Players").LocalPlayer.Character.Humanoid.MaxSlopeAngle = value
        end
    end
})

-- Hip Height
playerStuff:AddSlider('hipHeight', {
    Text = 'Hip-Height',
    Default = 2,
    Min = 2,
    Max = 10,
    Rounding = 1,
    Callback = function(value)
        if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") then
            game:GetService("Players").LocalPlayer.Character.Humanoid.HipHeight = value
        end
    end
})

-- Jump Power
playerStuff:AddSlider('jumpPower', {
    Text = 'Jump Power',
    Default = 50,
    Min = 50,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") then
            game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end
})

-- Health and Stats section
local playerStats = Tabs.Player:AddRightGroupbox('Player Stats')
playerStats:AddDivider()

-- Health display and controls
playerStats:AddLabel('Health: 0/0'):AddColorPicker('HealthColor', {
    Default = Color3.new(0, 1, 0),
    Title = 'Health Color'
})

-- Auto heal toggle
playerStats:AddToggle('autoHeal', {
    Text = 'Auto Heal',
    Default = false,
    Callback = function(value)
        _G.autoHeal = value
        if not _G.autoHeal then return end
        
        task.spawn(function()
            while _G.autoHeal do
                local max = getGlobal().stats.maxHealth
                local health = getGlobal().stats.health
                
                if health < max * 0.8 then -- Heal when below 80%
                    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        if v.Name:lower():find("heal") or v.Name:lower():find("potion") then
                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                            v:Activate()
                            wait(0.5)
                            break
                        end
                    end
                end
                wait(1)
            end
        end)
    end
})

-- Adding missing Player tab functions
local playerStuff2 = Tabs.Player:AddLeftGroupbox('Player Abilities')
playerStuff2:AddDivider()

-- Infinite Jump
playerStuff2:AddToggle('infiniteJump', {
    Text = 'Infinite Jump',
    Default = false,
    Callback = function(value)
        _G.infiniteJump = value
        if value then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if _G.infiniteJump and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                    game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
                end
            end)
        end
    end
})

-- No Fall Damage
playerStuff2:AddToggle('noFallDamage', {
    Text = 'No Fall Damage',
    Default = false,
    Callback = function(value)
        _G.noFallDamage = value
        if value then
            task.spawn(function()
                while _G.noFallDamage do
                    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                        local humanoid = game.Players.LocalPlayer.Character.Humanoid
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    end
                    wait(0.1)
                end
            end)
        else
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                local humanoid = game.Players.LocalPlayer.Character.Humanoid
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            end
        end
    end
})

-- Fly
playerStuff2:AddToggle('fly', {
    Text = 'Fly',
    Default = false,
    Callback = function(value)
        _G.fly = value
        if value then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                bodyVelocity.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
                
                task.spawn(function()
                    local UserInputService = game:GetService("UserInputService")
                    local camera = workspace.CurrentCamera
                    
                    while _G.fly and bodyVelocity.Parent do
                        local moveVector = Vector3.new(0, 0, 0)
                        
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            moveVector = moveVector + camera.CFrame.LookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            moveVector = moveVector - camera.CFrame.LookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            moveVector = moveVector - camera.CFrame.RightVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            moveVector = moveVector + camera.CFrame.RightVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            moveVector = moveVector + Vector3.new(0, 1, 0)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                            moveVector = moveVector - Vector3.new(0, 1, 0)
                        end
                        
                        bodyVelocity.Velocity = moveVector * 50
                        wait(0.1)
                    end
                end)
            end
        else
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local bodyVelocity = game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity")
                if bodyVelocity then
                    bodyVelocity:Destroy()
                end
            end
        end
    end
})

-- Adding missing UI Settings functions
local uiStuff = Tabs['UI Settings']:AddLeftGroupbox('UI Features')
uiStuff:AddDivider()

-- Anti-AFK
uiStuff:AddToggle('antiAFK', {
    Text = 'Anti-AFK',
    Default = false,
    Callback = function(value)
        _G.antiAFK = value
        if value then
            task.spawn(function()
                while _G.antiAFK do
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
                    wait(300) -- 5 minutes
                end
            end)
        end
    end
})

-- Auto Rejoin
uiStuff:AddToggle('autoRejoin', {
    Text = 'Auto Rejoin on Kick',
    Default = false,
    Callback = function(value)
        _G.autoRejoin = value
        if value then
            game.Players.PlayerRemoving:Connect(function(player)
                if player == game.Players.LocalPlayer and _G.autoRejoin then
                    wait(1)
                    game:GetService("TeleportService"):Teleport(game.PlaceId)
                end
            end)
        end
    end
})

-- FPS Counter
uiStuff:AddToggle('fpsCounter', {
    Text = 'FPS Counter',
    Default = false,
    Callback = function(value)
        _G.showFPS = value
        if value then
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "FPSCounter"
            screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            
            local fpsLabel = Instance.new("TextLabel")
            fpsLabel.Name = "FPSLabel"
            fpsLabel.Parent = screenGui
            fpsLabel.BackgroundTransparency = 1
            fpsLabel.Position = UDim2.new(0, 10, 0, 10)
            fpsLabel.Size = UDim2.new(0, 100, 0, 30)
            fpsLabel.Font = Enum.Font.SourceSansBold
            fpsLabel.TextColor3 = Color3.new(1, 1, 1)
            fpsLabel.TextSize = 18
            fpsLabel.TextStrokeTransparency = 0
            fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            task.spawn(function()
                local lastTime = tick()
                local frameCount = 0
                
                while _G.showFPS and fpsLabel.Parent do
                    frameCount = frameCount + 1
                    local currentTime = tick()
                    
                    if currentTime - lastTime >= 1 then
                        fpsLabel.Text = "FPS: " .. frameCount
                        frameCount = 0
                        lastTime = currentTime
                    end
                    
                    game:GetService("RunService").Heartbeat:Wait()
                end
            end)
        else
            local fpsGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("FPSCounter")
            if fpsGui then
                fpsGui:Destroy()
            end
        end
    end
})

-- Ping Display
uiStuff:AddToggle('pingDisplay', {
    Text = 'Ping Display',
    Default = false,
    Callback = function(value)
        _G.showPing = value
        if value then
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "PingDisplay"
            screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            
            local pingLabel = Instance.new("TextLabel")
            pingLabel.Name = "PingLabel"
            pingLabel.Parent = screenGui
            pingLabel.BackgroundTransparency = 1
            pingLabel.Position = UDim2.new(0, 10, 0, 50)
            pingLabel.Size = UDim2.new(0, 100, 0, 30)
            pingLabel.Font = Enum.Font.SourceSansBold
            pingLabel.TextColor3 = Color3.new(1, 1, 1)
            pingLabel.TextSize = 18
            pingLabel.TextStrokeTransparency = 0
            pingLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            task.spawn(function()
                while _G.showPing and pingLabel.Parent do
                    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
                    pingLabel.Text = "Ping: " .. ping
                    wait(1)
                end
            end)
        else
            local pingGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("PingDisplay")
            if pingGui then
                pingGui:Destroy()
            end
        end
    end
})

notify("UI Loaded Successfully.")

-- CODE

-- Enhanced Kill Aura with multi-target support from Herkle Hub
local function getClosestPlayers() -- returns closest players to your player
    local hrp = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position
    local closePlayers = {}

    for i, v in pairs(game.Players:GetPlayers()) do
        if v.Character ~= nil and v ~= game:GetService("Players").LocalPlayer and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v.Character:FindFirstChild("Humanoid").Health > 0 then
            local plr_pos = v.Character.HumanoidRootPart.Position
            local plr_distance = (hrp - plr_pos).Magnitude

            if plr_distance < Options.auraRange.Value then
                table.insert(closePlayers, { player = v, distance = plr_distance, entityID = v:GetAttribute('EntityID') })
            end
        end
    end

    -- Sort by distance
    table.sort(closePlayers, function(a, b)
        return a.distance < b.distance
    end)

    return closePlayers
end

-- Updated swing tool method from Herkle Hub for better resource compatibility
local function swingtool(targets)
    if Packets.SwingTool and Packets.SwingTool.send then
        if type(targets) == "table" then
            Packets.SwingTool.send(targets)
        else
            Packets.SwingTool.send(targets)
        end
    end
end

Toggles.killAura:OnChanged(function()
    if not Toggles.killAura.Value then return end

    task.spawn(function()
        while Toggles.killAura.Value do
            local closePlayers = getClosestPlayers()
            local maxTargets = tonumber(Options.auraTargets.Value) or 1
            local cooldown = tonumber(Options.auraSwingCooldown.Value) or 0.1
            local targets = {}

            for i = 1, math.min(maxTargets, #closePlayers) do
                if closePlayers[i] and closePlayers[i].entityID then
                    table.insert(targets, closePlayers[i].entityID)
                end
            end

            if #targets > 0 then
                swingtool(targets)
            end
            
            task.wait(cooldown)
        end
    end)
end)

-- Added Resource Aura functionality from Herkle Hub
Toggles.resourceAura:OnChanged(function()
    if not Toggles.resourceAura.Value then return end

    task.spawn(function()
        while Toggles.resourceAura.Value do
            local range = tonumber(Options.resourceAuraRange.Value) or 20
            local cooldown = tonumber(Options.resourceSwingCooldown.Value) or 0.1
            local targets = {}
            local allresources = {}

            for _, r in pairs(workspace.Resources:GetChildren()) do
                table.insert(allresources, r)
            end
            for _, r in pairs(workspace:GetChildren()) do
                if r:IsA("Model") and r.Name == "Gold Node" then
                    table.insert(allresources, r)
                end
            end

            for _, res in pairs(allresources) do
                if res:IsA("Model") and res:GetAttribute("EntityID") then
                    local eid = res:GetAttribute("EntityID")
                    local ppart = res.PrimaryPart or res:FindFirstChildWhichIsA("BasePart")
                    if ppart then
                        local dist = (ppart.Position - root.Position).Magnitude
                        if dist <= range then
                            table.insert(targets, eid)
                        end
                    end
                end
            end

            if #targets > 0 then
                swingtool(targets)
            end

            task.wait(cooldown)
        end
    end)
end)

-- Added Critter Aura functionality from Herkle Hub
Toggles.critterAura:OnChanged(function()
    if not Toggles.critterAura.Value then return end

    task.spawn(function()
        while Toggles.critterAura.Value do
            local range = tonumber(Options.critterAuraRange.Value) or 20
            local targetCount = tonumber(Options.critterTargets.Value) or 1
            local cooldown = tonumber(Options.critterSwingCooldown.Value) or 0.1
            local targets = {}

            for _, critter in pairs(workspace.Critters:GetChildren()) do
                if critter:IsA("Model") and critter:GetAttribute("EntityID") then
                    local eid = critter:GetAttribute("EntityID")
                    local ppart = critter.PrimaryPart or critter:FindFirstChildWhichIsA("BasePart")

                    if ppart then
                        local dist = (ppart.Position - root.Position).Magnitude
                        if dist <= range then
                            table.insert(targets, { eid = eid, dist = dist })
                        end
                    end
                end
            end

            if #targets > 0 then
                table.sort(targets, function(a, b)
                    return a.dist < b.dist
                end)

                local selectedTargets = {}
                for i = 1, math.min(targetCount, #targets) do
                    table.insert(selectedTargets, targets[i].eid)
                end

                swingtool(selectedTargets)
            end

            task.wait(cooldown)
        end
    end)
end)

-- Enhanced drop function from Herkle Hub
local function drop(itemname)
    local inventory = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory:FindFirstChild("List")
    if not inventory then return end

    for _, child in ipairs(inventory:GetChildren()) do
        if child:IsA("ImageLabel") and child.Name == itemname then
            if Packets and Packets.DropBagItem and Packets.DropBagItem.send then
                Packets.DropBagItem.send(child.LayoutOrder)
            end
        end
    end
end

-- Added auto drop functionality from Herkle Hub
local debounce = 0
local cd = 0.1
runs.Heartbeat:Connect(function()
    if Toggles.autoDrop and Toggles.autoDrop.Value then
        if tick() - debounce >= cd then
            local selectedItem = Options.autoDropItem.Value
            drop(selectedItem)
            debounce = tick()
        end
    end
end)

-- Added fruit to item ID mapping from Herkle Hub
local fruittoitemid = {
    Bloodfruit = 94,
    Bluefruit = 377,
    Lemon = 99,
    Coconut = 1,
    Jelly = 604,
    Banana = 606,
    Orange = 602,
    Oddberry = 32,
    Berry = 35,
    Strangefruit = 302,
    Strawberry = 282,
    Sunfruit = 128,
    Pumpkin = 80,
    ["Prickly Pear"] = 378,
    Apple = 243,
    Barley = 247,
    Cloudberry = 101,
    Carrot = 147
}

-- Added plant function from Herkle Hub
local plantedboxes = {}
local function plant(entityid, itemID)
    if Packets.InteractStructure and Packets.InteractStructure.send then
        Packets.InteractStructure.send({ entityID = entityid, itemID = itemID })
        plantedboxes[entityid] = true
    end
end

-- Added plant box detection function from Herkle Hub
local function getpbs(range)
    local plantboxes = {}
    for _, deployable in ipairs(workspace.Deployables:GetChildren()) do
        if deployable:IsA("Model") and deployable.Name == "Plant Box" then
            local entityid = deployable:GetAttribute("EntityID")
            local ppart = deployable.PrimaryPart or deployable:FindFirstChildWhichIsA("BasePart")
            if entityid and ppart then
                local dist = (ppart.Position - root.Position).Magnitude
                if dist <= range then
                    table.insert(plantboxes, { entityid = entityid, deployable = deployable, dist = dist })
                end
            end
        end
    end
    return plantboxes
end

-- Added bush detection function from Herkle Hub
local function getbushes(range, fruitname)
    local bushes = {}
    for _, model in ipairs(workspace:GetChildren()) do
        if model:IsA("Model") and model.Name:find(fruitname) then
            local ppart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            if ppart then
                local dist = (ppart.Position - root.Position).Magnitude
                if dist <= range then
                    local entityid = model:GetAttribute("EntityID")
                    if entityid then
                        table.insert(bushes, { entityid = entityid, model = model, dist = dist })
                    end
                end
            end
        end
    end
    return bushes
end

-- Updated tween function with slower speed for gold mining
local tweening = nil
local function tween(target, speed)
    if tweening then tweening:Cancel() end
    local player = game.Players.LocalPlayer
    tweening = customTween(player, target.Position, speed or 16)
    return tweening
end

-- Added plant box placement function from Herkle Hub
placestructure = function(gridsize)
    if not plr or not plr.Character then return end

    local torso = plr.Character:FindFirstChild("HumanoidRootPart")
    if not torso then return end

    local startpos = torso.Position - Vector3.new(0, 3, 0)
    local spacing = 6.04

    for x = 0, gridsize - 1 do
        for z = 0, gridsize - 1 do
            task.wait(0.3)
            local position = startpos + Vector3.new(x * spacing, 0, z * spacing)

            if Packets.PlaceStructure and Packets.PlaceStructure.send then
                Packets.PlaceStructure.send{
                    ["buildingName"] = "Plant Box",
                    ["yrot"] = 45,
                    ["vec"] = position,
                    ["isMobile"] = false
                }
            end
        end
    end
end

-- Added auto plant functionality from Herkle Hub
Toggles.autoPlant:OnChanged(function()
    if not Toggles.autoPlant.Value then return end

    task.spawn(function()
        while Toggles.autoPlant.Value do
            local range = 30
            local selectedfruit = Options.plantType.Value
            local itemID = fruittoitemid[selectedfruit] or 94
            local plantboxes = getpbs(range)
            table.sort(plantboxes, function(a, b) return a.dist < b.dist end)

            for _, box in ipairs(plantboxes) do
                if not box.deployable:FindFirstChild("Seed") then
                    plant(box.entityid, itemID)
                else
                    plantedboxes[box.entityid] = true
                end
            end
            task.wait(0.1)
        end
    end)
end)

-- Added auto harvest functionality from Herkle Hub
Toggles.autoHarvest:OnChanged(function()
    if not Toggles.autoHarvest.Value then return end

    task.spawn(function()
        while Toggles.autoHarvest.Value do
            local harvestrange = 30
            local selectedfruit = Options.plantType.Value
            local bushes = getbushes(harvestrange, selectedfruit)
            table.sort(bushes, function(a, b) return a.dist < b.dist end)
            for _, bush in ipairs(bushes) do
                Packets.Pickup.send(bush.entityid)
            end
            task.wait(0.1)
        end
    end)
end)

-- Added tween to plant box functionality from Herkle Hub
Toggles.tweenToPlantBox:OnChanged(function()
    if not Toggles.tweenToPlantBox.Value then return end

    task.spawn(function()
        while Toggles.tweenToPlantBox.Value do
            local range = tonumber(Options.tweenRange.Value) or 250
            local plantboxes = getpbs(range)
            table.sort(plantboxes, function(a, b) return a.dist < b.dist end)

            for _, box in ipairs(plantboxes) do
                if not box.deployable:FindFirstChild("Seed") then
                    local target = box.deployable.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                    tween(target)
                    break
                end
            end

            task.wait(0.1)
        end
    end)
end)

-- Added tween to bush functionality from Herkle Hub
Toggles.tweenToBush:OnChanged(function()
    if not Toggles.tweenToBush.Value then return end

    task.spawn(function()
        while Toggles.tweenToBush.Value do
            local range = tonumber(Options.tweenRange.Value) or 250
            local selectedfruit = Options.plantType.Value
            local bushes = getbushes(range, selectedfruit)
            table.sort(bushes, function(a, b) return a.dist < b.dist end)

            if #bushes > 0 then
                for _, bush in ipairs(bushes) do
                    local target = bush.model.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                    tween(target)
                    break
                end
            else
                local plantboxes = getpbs(range)
                table.sort(plantboxes, function(a, b) return a.dist < b.dist end)

                for _, box in ipairs(plantboxes) do
                    if not box.deployable:FindFirstChild("Seed") then
                        local target = box.deployable.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                        tween(target)
                        break
                    end
                end
            end

            task.wait(0.1)
        end
    end)
end)

-- Added Gold Node detection and auto gold functionality
local function getGoldNodes(range)
    local goldNodes = {}
    
    -- Check workspace for Gold Nodes
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name == "Gold Node" then
            local primaryPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if primaryPart then
                local distance = (primaryPart.Position - root.Position).Magnitude
                if distance <= range then
                    table.insert(goldNodes, {
                        model = obj,
                        part = primaryPart,
                        distance = distance,
                        position = primaryPart.Position
                    })
                end
            end
        end
    end
    
    -- Also check Resources folder for Gold Nodes
    if workspace:FindFirstChild("Resources") then
        for _, obj in ipairs(workspace.Resources:GetChildren()) do
            if obj:IsA("Model") and obj.Name == "Gold Node" then
                local primaryPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                
                if primaryPart then
                    local distance = (primaryPart.Position - root.Position).Magnitude
                    if distance <= range then
                        table.insert(goldNodes, {
                            model = obj,
                            part = primaryPart,
                            position = primaryPart.Position,
                            distance = distance
                        })
                    end
                end
            end
        end
    end
    
    return goldNodes
end

-- Updated auto gold toggle with improved swing method and slower tweening
Toggles.autoGold:OnChanged(function()
    _G.autoGold = Toggles.autoGold.Value
    if not _G.autoGold then return end
    
    task.spawn(function()
        while _G.autoGold do
            local goldNodes = getGoldNodes(tonumber(Options.autoGoldRange.Value) or 150)
            
            if #goldNodes > 0 then
                table.sort(goldNodes, function(a, b) return a.distance < b.distance end)
                local closestGold = goldNodes[1]
                
                -- Use custom tween function
                local player = game.Players.LocalPlayer
                local targetPos = closestGold.position + Vector3.new(0, closestGold.part.Size.Y + 5, 0)
                customTween(player, targetPos, 12) -- Slower speed for gold
                
                -- Attack the gold node using resource aura method
                if closestGold.model:GetAttribute("EntityID") then
                    local eid = closestGold.model:GetAttribute("EntityID")
                    Packets.SwingTool.send(eid)
                end
                
                -- Pickup any items
                for i, v in pairs(getClosestPickups(workspace)) do
                    game:GetService("ReplicatedStorage").Events.Pickup:FireServer(v)
                end
            end
            
            task.wait(0.1)
        end
    end)
end)

-- Modified existing tween functions to check for gold priority
local originalTweenToPlantBox = Toggles.tweenToPlantBox.Callback
Toggles.tweenToPlantBox.Callback = function()
    -- Check if gold is prioritized and available
    if Toggles.prioritizeGold and Toggles.prioritizeGold.Value and Toggles.autoGold and Toggles.autoGold.Value then
        local goldNodes = getGoldNodes(tonumber(Options.autoGoldRange.Value) or 150)
        if #goldNodes > 0 then
            return -- Don't tween to plant box if gold is available
        end
    end
    
    if originalTweenToPlantBox then
        originalTweenToPlantBox()
    end
end

local originalTweenToBush = Toggles.tweenToBush.Callback
Toggles.tweenToBush.Callback = function()
    -- Check if gold is prioritized and available
    if Toggles.prioritizeGold and Toggles.prioritizeGold.Value and Toggles.autoGold and Toggles.autoGold.Value then
        local goldNodes = getGoldNodes(tonumber(Options.autoGoldRange.Value) or 150)
        if #goldNodes > 0 then
            return -- Don't tween to bush if gold is available
        end
    end
    
    if originalTweenToBush then
        originalTweenToBush()
    end
end

-- Reverted to original auto pickup function from original script
local function getClosestPickups(folder)
    local Character = game:GetService("Players").LocalPlayer.Character
    local pickups = {}
    for i, v in pairs(folder:GetChildren()) do
        if v:IsA("BasePart") and table.find(pickups, v) == nil and Character:FindFirstChild("HumanoidRootPart") then
            if Toggles.whitelist.Value then
                if table.find(Options.items.Value, v.Name) then
                    if (Character.HumanoidRootPart.Position - v.Position).Magnitude <= 32 then
                        print("Picked up " ..
                            v.Name ..
                            ", at a distance of " ..
                            math.floor((Character.HumanoidRootPart.Position - v.Position).Magnitude))
                        table.insert(pickups, v)
                    end
                end
            else
                if (Character.HumanoidRootPart.Position - v.Position).Magnitude <= 32 then
                    print("Picked up " ..
                        v.Name ..
                        ", at a distance of " .. math.floor((Character.HumanoidRootPart.Position - v.Position).Magnitude))
                    table.insert(pickups, v)
                end
            end
        end
    end
    return pickups
end

Toggles.autoPickUp:OnChanged(function()
    if not Toggles.autoPickUp.Value then return end

    task.spawn(function()
        while Toggles.autoPickUp.Value do
            for i, v in pairs(getClosestPickups(workspace.Items)) do
                Packets.Pickup.send(v:GetAttribute("EntityID"))
            end
            task.wait()
        end
    end)
end)

-- Reverted to original auto heal function from original script
Toggles.autoHeal:OnChanged(function()
    if not Toggles.autoHeal.Value then return end

    task.spawn(function()
        while Toggles.autoHeal.Value do
            local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
            local fruit

            for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory.List:GetChildren()) do
                if (v:IsA("ImageLabel")) then
                    if (v.Name:lower() == Options.heals.Value:lower()) then
                        fruit = v; 
                    end
                end
            end

            while humanoid.Health < Options.autoHealThresh.Value do
                Packets.UseBagItem.send(fruit.LayoutOrder)
                Packets.UseBagItem.send(fruit.LayoutOrder)
                Packets.UseBagItem.send(fruit.LayoutOrder)
                Packets.UseBagItem.send(fruit.LayoutOrder)
                Packets.UseBagItem.send(fruit.LayoutOrder)
                print("Ate ",  fruit.Name, " health was ", humanoid.Health )
                task.wait()
            end
            task.wait()
        end
    end)
end)

-- Added custom tween function with 16 default speed
local function customTween(player, targetPosition, FarmingTweenSpeed)
    local TweenService = game:GetService("TweenService")
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        warn("Player does not have a character or HumanoidRootPart")
        return
    end

    local humanoidRootPart = player.Character.HumanoidRootPart
    local currentPosition = humanoidRootPart.Position
    local distance = (targetPosition - currentPosition).magnitude
    local duration = distance / (FarmingTweenSpeed or 16)

    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tweenGoal = { CFrame = CFrame.new(targetPosition)}
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, tweenGoal)

    tween:Play()
    return tween
end

-- Added loop walk speed function
local function loopWalkSpeed(player, speed)
    if player and speed and typeof(speed) == "number" then
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        
        local function updateWalkSpeed()
            humanoid.WalkSpeed = speed
        end
        
        updateWalkSpeed()
        
        local connection
        connection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            updateWalkSpeed()
        end)
        
        return connection
    else
        warn("Invalid arguments provided to loopWalkSpeed function.")
    end
end

-- Updated chest steal functionality
local function getClosestChestPickups(folder)
    local Character = game:GetService("Players").LocalPlayer.Character
    local pickups = {}
    for i, v in pairs(folder:GetChildren()) do
        if v:IsA("Model") and v.Name == "Chest" and table.find(pickups, v) == nil and Character:FindFirstChild("HumanoidRootPart") then
            if (Character.HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude <= 32 then
                print("Picked up " ..
                    v.Name ..
                    ", at a distance of " .. math.floor((Character.HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude))
                table.insert(pickups, v)
            end
        end
    end
    return pickups
end

Toggles.chestSteal:OnChanged(function()
    _G.chestSteal = Toggles.chestSteal.Value
    if not _G.chestSteal then return end
    
    task.spawn(function()
        while _G.chestSteal do
            for i, v in pairs(getClosestChestPickups(workspace.Deployables)) do
                if not _G.chestSteal then return end
                Packets.Pickup.send(v:GetAttribute("EntityID"))
            end
            wait(0.1)
        end
    end)
end)

-- Fixed UI Settings tab content organization
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddDivider()

-- Unload button
MenuGroup:AddButton({
    Text = 'Unload Script',
    Func = function() 
        Library:Unload() 
    end
})

-- Toggle keybind
MenuGroup:AddLabel('Toggle GUI'):AddKeyPicker('MenuKeybind', {
    Default = 'RightShift', 
    NoUI = false, 
    Text = 'Toggle GUI'
})

-- Server utilities section
local serverStuff = Tabs['UI Settings']:AddRightGroupbox('Server Utilities')
serverStuff:AddDivider()

serverStuff:AddButton({
    Text = 'Void Teleport',
    Func = function()
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, -1000, 0)
        end
    end
})

serverStuff:AddButton({
    Text = 'Rejoin Server',
    Tooltip = "Won't work with private servers.",
    Func = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

serverStuff:AddButton({
    Text = 'Join Small Server',
    Func = function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/"
        
        local _place = game.PlaceId
        local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
        
        local function ListServers(cursor)
            local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
            return Http:JSONDecode(Raw)
        end
        
        local Server, Next; repeat
            local Servers = ListServers(Next)
            Server = Servers.data[1]
            Next = Servers.nextPageCursor
        until Server
        
        TPS:TeleportToPlaceInstance(_place, Server.id, game.Players.LocalPlayer)
    end
})

-- Ensure proper library initialization at the end
Library.ToggleKeybind = Options.MenuKeybind

-- Initialize managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('ShadeHubEnhanced')
SaveManager:SetFolder('ShadeHubEnhanced/configs')

-- Build config and theme sections
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])

-- Load autoload config
SaveManager:LoadAutoloadConfig()