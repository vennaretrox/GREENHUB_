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
gui.Name = "GREENHUB_V16_FINAL_REBORN"

--------------------------------------------------
-- LOGO & ANIMATION (YEŞİL PARLAMA GERİ GELDİ)
--------------------------------------------------
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(60, 60)
btn.Position = UDim2.new(0, 50, 0, 50)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
btn.TextColor3 = Color3.fromRGB(0, 200, 0)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 24
btn.ZIndex = 10

local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 100, 0)
btnStroke.Thickness = 3
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 15)

-- Logo Yanıp Sönme Animasyonu (Loop)
task.spawn(function()
    while task.wait(0.8) do
        local targetColor = (btnStroke.Color == Color3.fromRGB(0, 100, 0)) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 100, 0)
        TweenService:Create(btnStroke, TweenInfo.new(0.8), {Color = targetColor}):Play()
        TweenService:Create(btn, TweenInfo.new(0.8), {TextColor3 = targetColor}):Play()
    end
end)

--------------------------------------------------
-- MENU & TITLES (GOTHAMBLACK FORSAKEN GERİ GELDİ)
--------------------------------------------------
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(230, 320)
menu.Position = UDim2.new(0, 50, 0, 120)
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
local menuStroke = Instance.new("UIStroke", menu)
menuStroke.Color = Color3.fromRGB(0, 150, 0)
menuStroke.Thickness = 4

local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "GREENHUB"
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local sub = Instance.new("TextLabel", menu)
sub.Size = UDim2.new(1, 0, 0, 15)
sub.Position = UDim2.new(0, 0, 0, 35)
sub.BackgroundTransparency = 1
sub.Text = "forsaken"
sub.TextColor3 = Color3.fromRGB(0, 120, 0)
sub.Font = Enum.Font.GothamBlack -- Tam istediğin stil
sub.TextSize = 13

-- Menü Açma Kapama Fix
btn.Activated:Connect(function()
    menu.Visible = not menu.Visible
end)

-- Drag Sistemi
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
        menu.Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset, btn.Position.Y.Scale, btn.Position.Y.Offset + 70)
    end
end)
UIS.InputEnded:Connect(function(input) dragging = false end)

--------------------------------------------------
-- SCROLL & BUTTONS
--------------------------------------------------
local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -20, 1, -120)
scroll.Position = UDim2.new(0, 10, 0, 80)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 8)

local function createButton(text, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    b.TextColor3 = Color3.fromRGB(0, 200, 0)
    b.Text = text
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(40, 40, 40)
    b.MouseButton1Click:Connect(function() callback(b, s) end)
    return b
end

createButton("Hyper Speed: OFF", function(self, s)
    hyperActive = not hyperActive
    self.Text = hyperActive and "Hyper Speed: ON" or "Hyper Speed: OFF"
    self.TextColor3 = hyperActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 200, 0)
end)

createButton("Anti-Attack: OFF", function(self, s)
    antiAttackActive = not antiAttackActive
    self.Text = antiAttackActive and "Anti-Attack: ON" or "Anti-Attack: OFF"
    self.TextColor3 = antiAttackActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 200, 0)
end)

--------------------------------------------------
-- ULTRA DEFENSE (DUVARLAR + REGEN + SLOW)
--------------------------------------------------
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    -- HIZ (1.8 Çarpanı)
    if hyperActive and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * hyperMultiplier)
    end

    if antiAttackActive then
        -- CAN POMPASI A
        hum.Health = 100
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

        -- GÖRÜNMEZ DUVAR + CEZA
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local kHrp = v.Character.HumanoidRootPart
                local dist = (hrp.Position - kHrp.Position).Magnitude
                if dist < 10 then -- 10 Metre Görünmez Duvar
                    kHrp.Velocity = (kHrp.Position - hrp.Position).Unit * 50
                    local kHum = v.Character:FindFirstChildOfClass("Humanoid")
                    if kHum then
                        kHum.WalkSpeed = 4 -- 7 Saniye Yavaşlatma
                        task.delay(7, function() if kHum then kHum.WalkSpeed = 16 end end)
                    end
                end
            end
        end
    end
end)

-- CAN POMPASI B (ARKADAN SPAM)
task.spawn(function()
    while task.wait() do
        if antiAttackActive and player.Character then
            local h = player.Character:FindFirstChildOfClass("Humanoid")
            if h then h.Health = 100 end
        end
    end
end)

-- ÖLÜM ENGELLEYİCİ (BYPASS)
local mt = getrawmetatable(game)
local old = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(function(t, k)
    if antiAttackActive and t:IsA("Humanoid") and k == "Health" then return 100 end
    return old(t, k)
end)
setreadonly(mt, true)
