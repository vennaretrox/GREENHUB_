-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local hyperActive = false
local antiAttackActive = false 
local e_active = false
local hyperMultiplier = 2.1

-- SCREEN GUI (LOGON, MENÜ VE TUŞLAR TİPATIP AYNI)
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_V55_PHANTOM"

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(60, 60)
btn.Position = UDim2.new(0, 50, 0, 50)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
btn.TextColor3 = Color3.fromRGB(0, 80, 0)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 22
btn.ZIndex = 10
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 40, 0)
btnStroke.Thickness = 2.5

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(250, 350)
menu.Position = UDim2.new(0, 50, 0, 120)
menu.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", menu).Color = Color3.fromRGB(0, 255, 0)

local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 15)
title.BackgroundTransparency = 1
title.Text = "GREENHUB"
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 24

local sub = Instance.new("TextLabel", menu)
sub.Size = UDim2.new(1, 0, 0, 20)
sub.Position = UDim2.new(0, 0, 0, 42)
sub.BackgroundTransparency = 1
sub.Text = "forsaken"
sub.TextColor3 = Color3.fromRGB(0, 120, 0)
sub.Font = Enum.Font.GothamBlack
sub.TextSize = 15

btn.Activated:Connect(function()
    menu.Visible = not menu.Visible
    local isVis = menu.Visible
    TweenService:Create(btn, TweenInfo.new(0.6), {TextColor3 = isVis and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 80, 0)}):Play()
    TweenService:Create(btnStroke, TweenInfo.new(0.6), {Color = isVis and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 40, 0), Thickness = isVis and 4 or 2.5}):Play()
end)

local dragging, dragStart, startPos
btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = btn.Position end end)
UIS.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) menu.Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset, btn.Position.Y.Scale, btn.Position.Y.Offset + 70) end end)
UIS.InputEnded:Connect(function(input) dragging = false end)

local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -20, 1, -120)
scroll.Position = UDim2.new(0, 10, 0, 95)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 10)

local function createButton(text, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 50)
    b.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    b.TextColor3 = Color3.fromRGB(0, 255, 0)
    b.Text = text .. ": OFF"
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        TweenService:Create(b, TweenInfo.new(0.3), {TextColor3 = active and Color3.fromRGB(140, 0, 255) or Color3.fromRGB(0, 255, 0)}):Play()
        b.Text = text .. (active and ": ON" or ": OFF")
        callback(active)
    end)
end

createButton("Hyper Speed", function(s) hyperActive = s end)
createButton("Anti-Attack", function(s) antiAttackActive = s end)

--------------------------------------------------
-- MASTER CORE (ALL POWERS IN ONE NEON BLOCK)
--------------------------------------------------

local singleNeonBlock = Instance.new("Part")
singleNeonBlock.Name = "TheOneAndOnlyCore"
singleNeonBlock.Size = Vector3.new(2.6, 3.6, 1.6)
singleNeonBlock.Material = Enum.Material.ForceField
singleNeonBlock.Color = Color3.fromRGB(0, 255, 0)
singleNeonBlock.Transparency = 0.3
singleNeonBlock.CanCollide = false
singleNeonBlock.CanTouch = false

UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.E and antiAttackActive then
        e_active = true
        task.wait(5)
        e_active = false
    end
end)

RunService.Heartbeat:Connect(function()
    pcall(function() Lighting.ColorCorrection.Saturation = 0 end)

    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    -- 1. LEGACY HYPER SPEED
    if hyperActive and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * hyperMultiplier)
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
    end

    -- 2. FULL UPGRADE ANTI-ATTACK
    if antiAttackActive then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum.BreakJointsOnDeath = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

        -- TEK NEON BLOK (TÜM GÜÇ BURADA)
        singleNeonBlock.Parent = char
        singleNeonBlock.CFrame = hrp.CFrame
        
        for _, p in pairs(char:GetChildren()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
                p.Transparency = 0.6
                p.Color = Color3.fromRGB(0, 255, 50)
                p.Material = Enum.Material.ForceField
            end
        end

        -- E TUŞU: LAG + KASIRGA + GERİ İTME + DONMA
        for _, other in pairs(Players:GetPlayers()) do
            if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
                local oHrp = other.Character.HumanoidRootPart
                local oHum = other.Character:FindFirstChildOfClass("Humanoid")
                local dist = (hrp.Position - oHrp.Position).Magnitude
                
                if dist < 25 then
                    if e_active then
                        -- FULL DOOM MOD (5 SN)
                        oHrp.CFrame = oHrp.CFrame * CFrame.new(0, 0, 1.5) -- Geri geri itme
                        oHrp.CFrame = oHrp.CFrame * CFrame.Angles(0, math.rad(115), 0) -- Kasırga
                        oHrp.Velocity = Vector3.new(math.random(-10,10), -50, math.random(-10,10)) -- Lag efekti
                        if oHum then oHum.WalkSpeed = 0 end
                    else
                        -- PASİF MOD
                        if oHum then oHum.WalkSpeed = 16 end
                        oHrp.CFrame = oHrp.CFrame * CFrame.Angles(0, math.rad(20), 0)
                    end
                end
            end
        end
    else
        singleNeonBlock.Parent = nil
    end
end)

-- 80 KATMANLI ÖLÜMSÜZLÜK MÜHRÜ
for i = 1, 80 do
    task.spawn(function()
        while true do
            if antiAttackActive then
                pcall(function() player.Character.Humanoid.Health = math.huge end)
            end
            task.wait()
        end
    end)
end
