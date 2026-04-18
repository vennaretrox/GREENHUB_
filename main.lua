-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- GUI CONTAINER
local gui = Instance.new("ScreenGui")
gui.Name = "GREENHUB_FIXED"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

--------------------------------------------------
-- LOGO BUTTON (G H) - ANA TAŞIYICI
--------------------------------------------------
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(55, 55)
btn.Position = UDim2.new(0, 30, 0, 30)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
btn.TextColor3 = Color3.fromRGB(0, 255, 120)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 22
btn.AutoButtonColor = false -- Sürüklerken renk değişimi çakışmasını önler

local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 120, 60)
btnStroke.Thickness = 2

local btnCorner = Instance.new("UICorner", btn)
btnCorner.CornerRadius = UDim.new(0, 12)

--------------------------------------------------
-- MENU PANEL
--------------------------------------------------
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(220, 250)
menu.Position = UDim2.new(0, 30, 0, 95) -- Başlangıçta logonun altında
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Visible = false
menu.ClipsDescendants = true

local menuStroke = Instance.new("UIStroke", menu)
menuStroke.Color = Color3.fromRGB(0, 120, 60)
menuStroke.Thickness = 1.8

local menuCorner = Instance.new("UICorner", menu)
menuCorner.CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "GREENHUB"
title.TextColor3 = Color3.fromRGB(0, 255, 120)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

--------------------------------------------------
-- DRAG SYSTEM (Sadece Logoyu Tutarak Her Şeyi Taşıma)
--------------------------------------------------
local dragging, dragInput, dragStart, startPos

btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = btn.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        
        -- Logoyu hareket ettir
        btn.Position = newPos
        -- Menüyü logonun hemen altına sabitle
        menu.Position = UDim2.new(newPos.X.Scale, newPos.X.Offset, newPos.Y.Scale, newPos.Y.Offset + 65)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

--------------------------------------------------
-- SCROLL AREA & BUTTON CREATOR
--------------------------------------------------
local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -16, 1, -50)
scroll.Position = UDim2.new(0, 8, 0, 40)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 120, 60)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 6)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 5)
end)

local function createButton(text, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    b.TextColor3 = Color3.fromRGB(0, 200, 100)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    Instance.new("UIStroke", b).Color = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(callback)
    return b
end

--------------------------------------------------
-- FEATURES
--------------------------------------------------
createButton("Speed: 357", function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 350
    end
end)

createButton("Normal Speed", function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
    end
end)

--------------------------------------------------
-- TOGGLE LOGIC
--------------------------------------------------
btn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
    btnStroke.Color = menu.Visible and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(0, 120, 60)
end)
