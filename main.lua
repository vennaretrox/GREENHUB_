-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local hyperActive = false
local antiAttackActive = false 
local hyperMultiplier = 1.8 

-- GUI CONTAINER
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_V21_LAG_BACK"

--------------------------------------------------
-- LOGO & SOFT TWEEN (0.6s PARILTI)
--------------------------------------------------
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(55, 55)
btn.Position = UDim2.new(0, 50, 0, 50)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
btn.TextColor3 = Color3.fromRGB(0, 150, 0)
btn.Font = Enum.Font.Gotham
btn.TextSize = 20
btn.ZIndex = 10

local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 80, 0)
btnStroke.Thickness = 2
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

--------------------------------------------------
-- MENU & TITLES (GOTHAMBLACK FORSAKEN)
--------------------------------------------------
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(225, 310)
menu.Position = UDim2.new(0, 50, 0, 115)
menu.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 8)
local menuStroke = Instance.new("UIStroke", menu)
menuStroke.Color = Color3.fromRGB(0, 150, 0)
menuStroke.Thickness = 3

local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "GREENHUB"
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 19

local sub = Instance.new("TextLabel", menu)
sub.Size = UDim2.new(1, 0, 0, 15)
sub.Position = UDim2.new(0, 0, 0, 32)
sub.BackgroundTransparency = 1
sub.Text = "forsaken"
sub.TextColor3 = Color3.fromRGB(0, 100, 0)
sub.Font = Enum.Font.GothamBlack
sub.TextSize = 12

-- Logo Tween Logic
btn.Activated:Connect(function()
    menu.Visible = not menu.Visible
    local targetColor = menu.Visible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 150, 0)
    TweenService:Create(btn, TweenInfo.new(0.6), {TextColor3 = targetColor}):Play()
    TweenService:Create(btnStroke, TweenInfo.new(0.6), {Color = targetColor, Thickness = menu.Visible and 3.5 or 2}):Play()
end)

-- Drag
local dragging, dragStart, startPos
btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = btn.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        menu.Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset, btn.Position.Y.Scale, btn.Position.Y.Offset + 65)
    end
end)
UIS.InputEnded:Connect(function(input) dragging = false end)

--------------------------------------------------
-- BUTTONS (OFF: YEŞİL / ON: KOYU MOR)
--------------------------------------------------
local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -20, 1, -100)
scroll.Position = UDim2.new(0, 10, 0, 75)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 8)

local function createButton(text, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    b.TextColor3 = Color3.fromRGB(0, 200, 0)
    b.Text = text .. ": OFF"
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        b.TextColor3 = active and Color3.fromRGB(120, 0, 200) or Color3.fromRGB(0, 200, 0)
        b.Text = text .. (active and ": ON" or ": OFF")
        callback(active)
    end)
    return b
end

createButton("Hyper Speed", function(s) hyperActive = s end)
createButton("Anti-Attack", function(s) antiAttackActive = s end)

--------------------------------------------------
-- LAG-BACK & GOD DEFENSE
--------------------------------------------------

-- E TUŞU: ULTIMATE DOOM (Sis + Yavaşlatma)
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.E and antiAttackActive then
        for _, other in pairs(Players:GetPlayers()) do
            if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
                local tHrp = other.Character.HumanoidRootPart
                local tHum = other.Character:FindFirstChildOfClass("Humanoid")
                local dist = (player.Character.HumanoidRootPart.Position - tHrp.Position).Magnitude
                
                if dist < 12 then
                    local s = Instance.new("Smoke", tHrp); s.Color = Color3.fromRGB(0,0,0); s.Size = 30; s.Opacity = 1
                    if tHum.WalkSpeed > 16 then tHum.WalkSpeed = 10 else tHum.WalkSpeed = 5 end
                    for _, tool in pairs(other.Character:GetChildren()) do if tool:IsA("Tool") then tool.Enabled = false end end
                    task.delay(7, function() s:Destroy(); if tHum then tHum.WalkSpeed = 16 end; for _, tool in pairs(other.Character:GetChildren()) do if tool:IsA("Tool") then tool.Enabled = true end end end)
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    -- HIZ (1.8X)
    if hyperActive and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * hyperMultiplier)
    end

    if antiAttackActive then
        -- GHOST MODE (İçinden Geçme)
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then part.CanTouch = false end
        end
        hum.Health = 100
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

        -- LAG-BACK SİSTEMİ (Katili Geri Işınlama)
        for _, other in pairs(Players:GetPlayers()) do
            if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
                local oHrp = other.Character.HumanoidRootPart
                local dist = (hrp.Position - oHrp.Position).Magnitude
                
                -- Eğer katil 4 metreden fazla yaklaşırsa "Lag" yemiş gibi 15 metre geriye atılır
                if dist < 4 then
                    local backDir = (oHrp.Position - hrp.Position).Unit
                    oHrp.CFrame = oHrp.CFrame + (backDir * 15) -- Işınlama (Lag etkisi)
                elseif dist < 8 then
                    -- 8 metredeyken hafif itme (Duvar hissi)
                    oHrp.Velocity = (oHrp.Position - hrp.Position).Unit * 40
                end
            end
        end
    end
end)

-- CAN POMPASI (Milli-Regen)
task.spawn(function()
    while task.wait() do
        if antiAttackActive and player.Character then
            local h = player.Character:FindFirstChildOfClass("Humanoid")
            if h then h.Health = 100 end
        end
    end
end)
