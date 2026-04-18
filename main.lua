-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- GUI CONTAINER
local gui = Instance.new("ScreenGui")
gui.Name = "GREENHUB_OFFICIAL"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

--------------------------------------------------
-- LOGO BUTTON (Aç/Kapat Tetikleyici)
--------------------------------------------------
local btn = Instance.new("TextButton", gui)
btn.Name = "ToggleButton"
btn.Size = UDim2.fromOffset(45, 45)
btn.Position = UDim2.new(0, 20, 0, 20)
btn.Text = "GH"
btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
btn.TextColor3 = Color3.fromRGB(0, 255, 120)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 18

local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 120, 60)
btnStroke.Thickness = 1.5

local btnCorner = Instance.new("UICorner", btn)
btnCorner.CornerRadius = UDim.new(0, 10)

--------------------------------------------------
-- MENU (Ana Panel)
--------------------------------------------------
local menu = Instance.new("Frame", gui)
menu.Name = "MainFrame"
menu.Size = UDim2.fromOffset(220, 280)
menu.Position = UDim2.new(0, 20, 0, 75) -- Logonun hemen altında başlar
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Visible = false -- Başlangıçta kapalı
menu.ClipsDescendants = true

local menuStroke = Instance.new("UIStroke", menu)
menuStroke.Color = Color3.fromRGB(0, 120, 60)
menuStroke.Thickness = 1.8

local menuCorner = Instance.new("UICorner", menu)
menuCorner.CornerRadius = UDim.new(0, 8)

-- Title
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "GREENHUB"
title.TextColor3 = Color3.fromRGB(0, 255, 120)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Subtitle
local sub = Instance.new("TextLabel", menu)
sub.Size = UDim2.new(1, 0, 0, 15)
sub.Position = UDim2.new(0, 0, 0, 28)
sub.BackgroundTransparency = 1
sub.Text = "forsaken edition"
sub.TextColor3 = Color3.fromRGB(0, 120, 60)
sub.Font = Enum.Font.GothamMedium
sub.TextSize = 10

--------------------------------------------------
-- SCROLL AREA
--------------------------------------------------
local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -16, 1, -70)
scroll.Position = UDim2.new(0, 8, 0, 60)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 120, 60)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 6)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 5)
end)

--------------------------------------------------
-- BUTTON CREATOR FUNCTION
--------------------------------------------------
local function createButton(text, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 32)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    b.TextColor3 = Color3.fromRGB(0, 200, 100)
    b.Font = Enum.Font.Gotham
    b.TextSize = 13
    b.AutoButtonColor = true

    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(40, 40, 40)
    s.Thickness = 1

    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 4)

    b.MouseButton1Click:Connect(callback)
    return b
end

--------------------------------------------------
-- FEATURES (Örnek Fonksiyonlar)
--------------------------------------------------
createButton("Speed (50)", function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 50
    end
end)

createButton("Jump (100)", function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = 100
        char.Humanoid.UseJumpPower = true
    end
end)

createButton("Reset Stats", function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 16
        char.Humanoid.JumpPower = 50
    end
end)

--------------------------------------------------
-- TOGGLE LOGIC (Logoya Basınca Aç/Kapat)
--------------------------------------------------
btn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
    
    -- Küçük bir animasyon efekti (Basıldığında buton parlar)
    if menu.Visible then
        btnStroke.Color = Color3.fromRGB(0, 255, 120)
    else
        btnStroke.Color = Color3.fromRGB(0, 120, 60)
    end
end)
