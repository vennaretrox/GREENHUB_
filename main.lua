-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local hyperActive = false
local antiAttackActive = false 
local hyperMultiplier = 2.1

-- SCREEN GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_V41_FINAL"

--------------------------------------------------
-- MENÜ VE LOGO (TIPA TIP AYNI)
--------------------------------------------------
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
-- FORSAKEN BYPASS LOGIC
--------------------------------------------------

-- E TUŞU: 17 SANİYE CRASH LAG
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.E and antiAttackActive then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local vHrp = v.Character.HumanoidRootPart
                if (player.Character.HumanoidRootPart.Position - vHrp.Position).Magnitude < 30 then
                    task.spawn(function()
                        local start = tick()
                        while tick() - start < 17 do
                            if vHrp then
                                vHrp.Anchored = true
                                -- ŞİDDETLİ LAG VE DÖNME (CRASH MODU)
                                vHrp.CFrame = vHrp.CFrame * CFrame.Angles(0, math.rad(90), 0)
                                vHrp.Velocity = Vector3.new(0, 1000000, 0)
                                -- Katilin sunucuyla olan senkronizasyonunu boz
                                settings().Physics.PhysicsEnvironmentalThrottle = 1
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

-- ANA KORUMA DÖNGÜSÜ
RunService.Stepped:Connect(function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    -- 1. BAĞIMSIZ LEGACY SPEED
    if hyperActive and hrp and hum and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * hyperMultiplier)
    end

    -- 2. ANTI-ATTACK & ANTI-LOBBY
    if antiAttackActive and hrp and hum then
        -- VÜCUDA ÇAKILI YEŞİL ZIRH
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanTouch = false
                p.CanQuery = false
                p.Color = Color3.fromRGB(0, 255, 50)
                p.Material = Enum.Material.ForceField
                p.Transparency = 0.5
            end
        end

        -- LOBBY'YE IŞINLANMAYI ENGELLE (ANTI-VOID)
        hrp.Velocity = Vector3.new(0, 0, 0) -- Işınlanma hızını sıfırla
        
        -- KATİLLERİ DONDUR VE DÖNDÜR
        for _, enemy in pairs(Players:GetPlayers()) do
            if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                local eHrp = enemy.Character.HumanoidRootPart
                local dist = (hrp.Position - eHrp.Position).Magnitude
                if dist < 30 then
                    -- GERÇEK DONMA VE 360 DÖNME
                    eHrp.CFrame = eHrp.CFrame * CFrame.Angles(0, math.rad(45), 0)
                    eHrp.AssemblyLinearVelocity = Vector3.new(0, -1000, 0)
                end
            end
        end

        -- ÖLÜMSÜZLÜK
        if hum.Health < 100 then hum.Health = 100 end
    end
end)

-- 70X MEGA REGEN (LOBBY IŞINLAMASINA KARŞI SÜREKLİ YAPIlandırma)
for i = 1, 70 do
    task.spawn(function()
        while true do
            if antiAttackActive and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.Health = 100
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end
            end
            task.wait()
        end
    end)
end
