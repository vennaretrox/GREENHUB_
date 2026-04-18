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
gui.Name = "GREENHUB_GOD_V26"

--------------------------------------------------
-- LOGO & 0.6s SOFT PARILTI
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
-- MENU (GOTHAMBLACK FORSAKEN)
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
btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = btn.Position end end)
UIS.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) menu.Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset, btn.Position.Y.Scale, btn.Position.Y.Offset + 65) end end)
UIS.InputEnded:Connect(function(input) dragging = false end)

--------------------------------------------------
-- BUTTONS (OFF: YEŞİL / ON: MOR)
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
-- THE 7-LAYER SPHERE SHIELD & ULTRA LAG
--------------------------------------------------

local rotationAngle = 0

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    -- HIZ
    if hyperActive and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * hyperMultiplier)
    end

    if antiAttackActive then
        -- 1. KATMAN KORUMA: CAN & ANIMASYON KİLİDİ
        hum.Health = 100
        for _, track in pairs(hum:GetPlayingAnimationTracks()) do track:Stop() end
        
        -- GHOST MODE (CANTOUCH BYPASS)
        for _, p in pairs(char:GetChildren()) do
            if p:IsA("BasePart") then p.CanTouch = false p.CanQuery = false end
        end

        -- 2. KATMAN: ULTRA LAG & ORBIT SİSTEMİ
        rotationAngle = rotationAngle + 0.1
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local vHrp = v.Character.HumanoidRootPart
                local dist = (hrp.Position - vHrp.Position).Magnitude
                
                -- 7 KATMANLI KONTROL
                if dist < 12 then
                    -- KATİLİ ETRAFINDA DÖNDÜR (ORBIT)
                    if dist < 6 then
                        local offset = Vector3.new(math.cos(rotationAngle) * 8, 2, math.sin(rotationAngle) * 8)
                        vHrp.CFrame = CFrame.new(hrp.Position + offset, hrp.Position)
                    end
                    
                    -- ULTRA LAG-BACK (IŞINLAMA)
                    if dist < 4 then
                        -- En iç katman: 30 metre uzağa fırlat
                        vHrp.CFrame = vHrp.CFrame * CFrame.new(0, 0, 30)
                    elseif dist < 10 then
                        -- Dış katmanlar: Sürekli titret ve geri it (Lag efekti)
                        vHrp.CFrame = vHrp.CFrame * CFrame.new(math.random(-2,2), 0, 2.5)
                    end
                end
            end
        end
    end
end)

-- E TUŞU: KATİLİ "LAG VOID"E SOK
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.E and antiAttackActive then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local vHrp = v.Character.HumanoidRootPart
                if (player.Character.HumanoidRootPart.Position - vHrp.Position).Magnitude < 15 then
                    -- Katilin ekranını kör eden Weld-Box
                    local b = Instance.new("Part", v.Character)
                    b.Size = Vector3.new(10, 10, 10)
                    b.Color = Color3.fromRGB(0,0,0)
                    b.Material = Enum.Material.Neon
                    b.CanCollide = false
                    local w = Instance.new("Weld", b)
                    w.Part0 = b w.Part1 = vHrp
                    
                    task.spawn(function()
                        for i = 1, 150 do -- 7 Saniye boyunca her karede farklı yere ışınla (Deli Lag)
                            if vHrp then
                                vHrp.CFrame = vHrp.CFrame * CFrame.new(0, 0, 5) * CFrame.Angles(0, math.rad(45), 0)
                            end
                            task.wait()
                        end
                        b:Destroy()
                    end)
                end
            end
        end
    end
end)

-- MİLLİ-REGEN (ÖLÜMSÜZLÜK)
task.spawn(function()
    while task.wait() do
        if antiAttackActive and player.Character then
            local h = player.Character:FindFirstChildOfClass("Humanoid")
            if h then h.Health = 100 end
        end
    end
end)
