-- CustomUI.lua
-- Custom Neptune-themed UI module
local CustomUI = {}

-- Example function to create a main window
function CustomUI:createMainWindow(theme)

    local TweenService = game:GetService("TweenService")
    local window = Instance.new("ScreenGui")
    window.Name = "NeptuneUI"
    window.ResetOnSpawn = false

    local bg = Instance.new("Frame", window)
    bg.Size = UDim2.new(0.4, 0, 0.5, 0)
    bg.Position = UDim2.new(0.5, 0, 0.5, 0)
    bg.AnchorPoint = Vector2.new(0.5, 0.5)
    bg.BackgroundColor3 = Color3.fromHex(theme.background or "#222222")
    bg.BorderSizePixel = 0
    bg.BackgroundTransparency = 1 -- Start transparent for fade-in
    bg.Name = "MainBackground"
    bg.ClipsDescendants = true
    bg.ZIndex = 1
    bg.Parent = window

    -- Rounded corners
    local corner = Instance.new("UICorner", bg)
    corner.CornerRadius = UDim.new(0, 18)

    -- Drop shadow
    local shadow = Instance.new("ImageLabel", bg)
    shadow.Size = UDim2.new(1, 24, 1, 24)
    shadow.Position = UDim2.new(0, -12, 0, -12)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217" -- Roblox built-in shadow asset
    shadow.ImageTransparency = 0.5
    shadow.ZIndex = 0


    local emblem = Instance.new("ImageLabel", bg)
    emblem.Size = UDim2.new(0, 96, 0, 96)
    emblem.Position = UDim2.new(0.5, -48, 0, -48)
    emblem.BackgroundTransparency = 1
    emblem.Image = theme.emblemAssetId or "rbxassetid://124535" -- Provide emblem asset ID in theme
    emblem.Name = "DICKBLEM"
    emblem.ZIndex = 2


    local title = Instance.new("TextLabel", bg)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 60)
    title.BackgroundTransparency = 1
    title.Text = "Neptune Rework"
    title.TextColor3 = Color3.fromHex(theme.foreground or "#ffffff")
    title.Font = Enum.Font.GothamBold
    title.TextSize = 32
    title.ZIndex = 2

    local accentBar = Instance.new("Frame", bg)
    accentBar.Size = UDim2.new(1, 0, 0, 6)
    accentBar.Position = UDim2.new(0, 0, 0, 0)
    accentBar.BackgroundColor3 = Color3.fromHex(theme.accent or "#0078d7")
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 3

    -- Smooth fade-in
    TweenService:Create(bg, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.1}):Play()

    return window
end

return CustomUI
