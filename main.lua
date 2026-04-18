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
gui.Name = "GREENHUB_V17_REFINED"

--------------------------------------------------
-- LOGO (İNCE G H VE IŞIKLI SİSTEM)
--------------------------------------------------
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(55, 55)
btn.Position = UDim2.new(0, 50, 0, 50)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
btn.TextColor3 = Color3.fromRGB(0, 180, 0) -- Normal Yeşil
btn.Font = Enum.Font.Gotham -- Daha ince durması için
btn.TextSize = 20
btn.ZIndex = 10

local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 80, 0)
btnStroke.Thickness = 2
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

--------------------------------------------------
-- MENU & TITLES
--------------------------------------------------
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(225, 310)
menu.Position = UDim2.new(0, 50, 0, 115)
menu.BackgroundColor3 = Color3.fromRGB(5, 5, 5) -- Saf Siyah
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

-- TIKLAMA VE IŞIK EFEKTİ
btn.Activated:Connect(function()
    menu.Visible = not menu.Visible
    if menu.Visible then
        -- Menü açılınca parlak ışık
        btn.TextColor3 = Color3.fromRGB(0, 255, 0)
        btnStroke.Color = Color3.fromRGB(0, 255, 0)
        btnStroke.Thickness = 3
    else
        -- Menü kapanınca normal
        btn.TextColor3 = Color3.fromRGB(0, 180, 0)
        btnStroke.Color = Color3.fromRGB(0, 80, 0)
        btnStroke.Thickness = 2
    end
end)

-- Sürükleme
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
-- BUTTONS (KOYU MOR & YEŞİL SİSTEMİ)
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
    b.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- Buton Arkaplan Siyah
    b.TextColor3 = Color3.fromRGB(0, 200, 0) -- Başlangıç Yeşil (OFF)
    b.Text = text .. ": OFF"
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(30, 30, 30)
    
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        if active then
            b.TextColor3 = Color3.fromRGB(100, 0, 180) -- Koyu Mor
            b.Text = text .. ": ON"
        else
            b.TextColor3 = Color3.fromRGB(0, 200, 0) -- Yeşil
            b.Text = text .. ": OFF"
        end
        callback(active)
    end)
    return b
end

createButton("Hyper Speed", function(state) hyperActive = state end)
createButton("Anti-Attack", function(state) antiAttackActive = state end)

--------------------------------------------------
-- THE CORE: ANTI-ATTACK & SPEED
--------------------------------------------------
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

    -- ANTI-ATTACK SİSTEMİ (UPGRADED)
    if antiAttackActive then
        -- 1. Can Pompası
        hum.Health = 100
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

        -- 2. Görünmez Duvar & Katil Cezası
        for _, other in pairs(Players:GetPlayers()) do
            if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
                local targetHrp = other.Character.HumanoidRootPart
                local dist = (hrp.Position - targetHrp.Position).Magnitude
                
                if dist < 9 then -- 9 Metre Kalkan
                    targetHrp.Velocity = (targetHrp.Position - hrp.Position).Unit * 55
                    local targetHum = other.Character:FindFirstChildOfClass("Humanoid")
                    if targetHum then
                        targetHum.WalkSpeed = 3 -- Yavaşlat
                        task.delay(7, function() if targetHum then targetHum.WalkSpeed = 16 end end)
                    end
                end
            end
        end
    end
end)

-- ARKADAN CAN POMPASI (MİLLİ-REGEN SPAM)
task.spawn(function()
    while task.wait() do
        if antiAttackActive and player.Character then
            local h = player.Character:FindFirstChildOfClass("Humanoid")
            if h then h.Health = 100 end
        end
    end
end)
