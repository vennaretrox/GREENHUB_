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
gui.Name = "GREENHUB_GUARDIAN_ULTRA"

--------------------------------------------------
-- LOGO & DRAG SYSTEM (SAF KOYU YEŞİL)
--------------------------------------------------
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(55, 55)
btn.Position = UDim2.new(0, 30, 0, 30)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
btn.TextColor3 = Color3.fromRGB(0, 200, 0)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 22

local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 80, 0)
btnStroke.Thickness = 2
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(220, 300)
menu.Position = UDim2.new(0, 30, 0, 95)
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 8)
local menuStroke = Instance.new("UIStroke", menu)
menuStroke.Color = Color3.fromRGB(0, 120, 0)
menuStroke.Thickness = 4 

-- Drag Logic
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
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

--------------------------------------------------
-- TITLE & SUBTITLE
--------------------------------------------------
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "GREENHUB"
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local sub = Instance.new("TextLabel", menu)
sub.Size = UDim2.new(1, 0, 0, 15)
sub.Position = UDim2.new(0, 0, 0, 30)
sub.BackgroundTransparency = 1
sub.Text = "guardian"
sub.TextColor3 = Color3.fromRGB(0, 100, 0)
sub.Font = Enum.Font.GothamBlack
sub.TextSize = 12

--------------------------------------------------
-- SCROLL & BUTTONS
--------------------------------------------------
local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -16, 1, -100)
scroll.Position = UDim2.new(0, 8, 0, 65)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 6)

local function createButton(text, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    b.TextColor3 = Color3.fromRGB(0, 200, 0)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", b).Color = Color3.fromRGB(40, 40, 40)
    b.MouseButton1Click:Connect(function() callback(b) end)
    return b
end

createButton("Hyper Speed: OFF", function(self)
    hyperActive = not hyperActive
    self.Text = hyperActive and "Hyper Speed: ON" or "Hyper Speed: OFF"
    self.TextColor3 = hyperActive and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(0, 200, 0)
end)

createButton("Anti-Attack: OFF", function(self)
    antiAttackActive = not antiAttackActive
    self.Text = antiAttackActive and "Anti-Attack: ON" or "Anti-Attack: OFF"
    self.TextColor3 = antiAttackActive and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(0, 200, 0)
end)

--------------------------------------------------
-- GUARDIAN SYSTEM (AURA & PUNISH)
--------------------------------------------------

-- Katili Cezalandırma Fonksiyonu
local function punishKiller(killer)
    local hum = killer:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = 4 -- Fena yavaşlat
        -- Yetenekleri kapatma simülasyonu (Aletleri siler veya deaktive eder)
        for _, tool in pairs(killer:GetChildren()) do
            if tool:IsA("Tool") then tool.Parent = nil end
        end
        
        -- 7 Saniye sonra geri getirme (isteğe bağlı)
        task.delay(7, function()
            if hum then hum.WalkSpeed = 16 end
        end)
    end
end

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char or not antiAttackActive then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    if hrp and hum then
        -- 1. TRIPLE REGEN (3 Koldan Can)
        hum.Health = 100
        
        -- 2. GÖRÜNMEZ DUVAR VE CEZALANDIRMA MANTIĞI
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetHrp = otherPlayer.Character.HumanoidRootPart
                local dist = (hrp.Position - targetHrp.Position).Magnitude
                
                if dist < 8 then -- Eğer katil 8 metreden fazla yaklaşırsa
                    -- Geri itme (Görünmez duvar etkisi)
                    local pushDir = (targetHrp.Position - hrp.Position).Unit
                    targetHrp.Velocity = pushDir * 50
                    
                    -- Cezalandır
                    punishKiller(otherPlayer.Character)
                end
            end
        end

        -- 3. HIZ SİSTEMİ
        if hyperActive and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * hyperMultiplier)
        end
    end
end)

-- EKSTRA CAN POMPASI (TASK SPAWN)
task.spawn(function()
    while task.wait() do
        if antiAttackActive and player.Character then
            local h = player.Character:FindFirstChildOfClass("Humanoid")
            if h then h.Health = 100 end
        end
    end
end)

--------------------------------------------------
-- TOGGLE & LOGO ANIMATION (KOYU YEŞİL)
--------------------------------------------------
btn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
    if menu.Visible then
        TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 255, 0), Thickness = 4}):Play()
    else
        TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 80, 0), Thickness = 2}):Play()
    end
end)
