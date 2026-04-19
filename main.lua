-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local hyperActive = false
local antiAttackActive = false 
local hyperMultiplier = 2.2

-- SCREEN GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_V35_FINAL"

--------------------------------------------------
-- SİNEMATİK LOGO & PARILTI
--------------------------------------------------
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(55, 55)
btn.Position = UDim2.new(0, 50, 0, 50)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
btn.TextColor3 = Color3.fromRGB(0, 80, 0)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 20
btn.ZIndex = 10
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 40, 0)
btnStroke.Thickness = 2

--------------------------------------------------
-- MENU (BAŞLIKLAR & STİL)
--------------------------------------------------
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(225, 310)
menu.Position = UDim2.new(0, 50, 0, 115)
menu.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", menu).Color = Color3.fromRGB(0, 150, 0)

local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 12)
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
sub.Font = Enum.Font.GothamBlack
sub.TextSize = 13

-- Logo Glow Animasyonu (0.6s)
btn.Activated:Connect(function()
    menu.Visible = not menu.Visible
    local isVisible = menu.Visible
    TweenService:Create(btn, TweenInfo.new(0.6), {TextColor3 = isVisible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 80, 0)}):Play()
    TweenService:Create(btnStroke, TweenInfo.new(0.6), {Color = isVisible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 40, 0), Thickness = isVisible and 3.5 or 2}):Play()
end)

-- Dragging
local dragging, dragStart, startPos
btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = btn.Position end end)
UIS.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) menu.Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset, btn.Position.Y.Scale, btn.Position.Y.Offset + 65) end end)
UIS.InputEnded:Connect(function(input) dragging = false end)

--------------------------------------------------
-- BUTTONS
--------------------------------------------------
local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -20, 1, -110)
scroll.Position = UDim2.new(0, 10, 0, 85)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 8)

local function createButton(text, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    b.TextColor3 = Color3.fromRGB(0, 200, 0)
    b.Text = text .. ": OFF"
    b.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        TweenService:Create(b, TweenInfo.new(0.3), {TextColor3 = active and Color3.fromRGB(140, 0, 255) or Color3.fromRGB(0, 200, 0)}):Play()
        b.Text = text .. (active and ": ON" or ": OFF")
        callback(active)
    end)
end

createButton("Hyper Speed", function(s) hyperActive = s end)
createButton("Anti-Attack", function(s) antiAttackActive = s end)

--------------------------------------------------
-- THE ULTIMATE PROTECTION (GHOST CFRAME)
--------------------------------------------------

RunService.RenderStepped:Connect(function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    if antiAttackActive then
        -- 1. YEŞİL ZIRH & HİTBOX MANİPÜLASYONU
        -- Her bir parçayı Forcefield ve Yeşil yap, aynı zamanda etkileşimi kes
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanTouch = false
                part.CanQuery = false
                part.Color = Color3.fromRGB(0, 255, 100)
                part.Material = Enum.Material.ForceField
                part.Transparency = 0.6
            end
        end

        -- 2. 20M ULTRA LAG & FREEZE ZONE (SABİT KALKAN)
        for _, enemy in pairs(Players:GetPlayers()) do
            if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                local eHrp = enemy.Character.HumanoidRootPart
                local eHum = enemy.Character:FindFirstChildOfClass("Humanoid")
                local dist = (hrp.Position - eHrp.Position).Magnitude
                
                if dist < 20 then
                    -- Katilin bağlantısını koparacak kadar lag
                    eHrp.Velocity = Vector3.new(0, -2000, 0) -- Yere göm
                    eHrp.CFrame = eHrp.CFrame * CFrame.new(0, 0, 6) * CFrame.Angles(0, math.rad(20), 0)
                    if eHum then eHum.PlatformStand = true end -- Saldırı yapmasını engelle
                end
            end
        end

        -- 3. ÖLÜMÜN ÖNÜNE GEÇ (INSTANT RESET BYPASS)
        if hum.Health < 100 then hum.Health = 100 end
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) -- Ölmeyi yasakla
    end

    -- SPEED
    if hyperActive and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * hyperMultiplier)
    end
end)

-- E TUŞU: TOTAL FREEZE
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.E and antiAttackActive then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local vHrp = v.Character.HumanoidRootPart
                if (player.Character.HumanoidRootPart.Position - vHrp.Position).Magnitude < 20 then
                    task.spawn(function()
                        local lockCF = vHrp.CFrame
                        for i = 1, 500 do
                            if vHrp then
                                vHrp.Anchored = true
                                vHrp.CFrame = lockCF * CFrame.Angles(0, math.rad(i*10), 0)
                            end
                            RunService.Heartbeat:Wait()
                        end
                        if vHrp then vHrp.Anchored = false end
                    end)
                end
            end
        end
    end
end)

-- 30X MEGA REGEN (PARALEL ÇALIŞMA)
for i = 1, 30 do
    task.spawn(function()
        while true do
            if antiAttackActive and player.Character then
                local h = player.Character:FindFirstChildOfClass("Humanoid")
                if h then h.Health = 100 end
            end
            task.wait()
        end
    end)
end
