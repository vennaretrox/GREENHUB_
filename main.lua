-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local hyperActive = false
local antiAttackActive = false 
local hyperMultiplier = 2.0

-- SCREEN GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_V32_EMERALD"

--------------------------------------------------
-- SİNEMATİK LOGO (0.6s PARILTI)
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
sub.TextColor3 = Color3.fromRGB(0, 120, 0)
sub.Font = Enum.Font.GothamBlack
sub.TextSize = 12

-- Glow Animation
btn.Activated:Connect(function()
    menu.Visible = not menu.Visible
    local isVisible = menu.Visible
    local targetText = isVisible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 80, 0)
    local targetStroke = isVisible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 40, 0)
    
    TweenService:Create(btn, TweenInfo.new(0.6, Enum.EasingStyle.Quart), {TextColor3 = targetText}):Play()
    TweenService:Create(btnStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quart), {Color = targetStroke, Thickness = isVisible and 3.5 or 2}):Play()
end)

-- Dragging
local dragging, dragStart, startPos
btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = btn.Position end end)
UIS.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) menu.Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset, btn.Position.Y.Scale, btn.Position.Y.Offset + 65) end end)
UIS.InputEnded:Connect(function(input) dragging = false end)

local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -20, 1, -100)
scroll.Position = UDim2.new(0, 10, 0, 75)
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
    b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        local targetColor = active and Color3.fromRGB(140, 0, 255) or Color3.fromRGB(0, 200, 0)
        TweenService:Create(b, TweenInfo.new(0.3), {TextColor3 = targetColor}):Play()
        b.Text = text .. (active and ": ON" or ": OFF")
        callback(active)
    end)
end

createButton("Hyper Speed", function(s) hyperActive = s end)
createButton("Anti-Attack", function(s) antiAttackActive = s end)

--------------------------------------------------
-- EMERALD PROTECTION & FREEZE LAGG
--------------------------------------------------

-- E TUŞU: TOTAL FREEZE (7 SANİYE)
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.E and antiAttackActive then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local vHrp = v.Character.HumanoidRootPart
                if (player.Character.HumanoidRootPart.Position - vHrp.Position).Magnitude < 17 then
                    task.spawn(function()
                        local startPos = vHrp.CFrame
                        local t = 0
                        while t < 7 do
                            if vHrp then
                                vHrp.Anchored = true
                                vHrp.CFrame = startPos * CFrame.new(math.random(-0.02, 0.02), 0, math.random(-0.02, 0.02))
                            end
                            t = t + task.wait()
                        end
                        if vHrp then vHrp.Anchored = false end
                    end)
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    if antiAttackActive then
        -- 1. YEŞİL SAYDAM KORUMA (TAM VÜCUDA SABİT)
        for _, p in pairs(char:GetChildren()) do
            if p:IsA("BasePart") then
                p.CanTouch = false
                p.CanQuery = false
                p.Color = Color3.fromRGB(0, 255, 100) -- HAFİF YEŞİL
                p.Transparency = 0.6 -- SAYDAM
                p.Material = Enum.Material.ForceField -- YEŞİL PARILTI EFEKTİ
            end
        end

        -- 2. ULTRA LAG BOMBASI (40 KATMAN - 17M)
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local vHrp = v.Character.HumanoidRootPart
                local dist = (hrp.Position - vHrp.Position).Magnitude
                if dist < 17 then
                    -- Lag şiddeti artırıldı: Rastgele eksenlerde aşırı geri itme
                    vHrp.CFrame = vHrp.CFrame * CFrame.new(0, 0, 5) 
                    vHrp.Velocity = Vector3.new(math.random(-100,100), -500, math.random(-100,100))
                end
            end
        end
    end

    if hyperActive and hum and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * hyperMultiplier)
    end
end)

-- 10X CAN POMPALAMA (KESİN ÖLÜMSÜZLÜK)
for i = 1, 10 do
    task.spawn(function()
        while true do
            if antiAttackActive and player.Character then
                local h = player.Character:FindFirstChildOfClass("Humanoid")
                if h then 
                    h.Health = 100 
                    if h.Health < 100 then h.Health = 100 end
                end
            end
            RunService.RenderStepped:Wait()
        end
    end)
end
