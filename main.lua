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
gui.Name = "GREENHUB_ULTRA_FORSAKEN_GOD"

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
btn.AutoButtonColor = false

local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 100, 0)
btnStroke.Thickness = 2
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(220, 300)
menu.Position = UDim2.new(0, 30, 0, 95)
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 8)
local menuStroke = Instance.new("UIStroke", menu)
menuStroke.Color = Color3.fromRGB(0, 150, 0)
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
        local nPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        btn.Position = nPos
        menu.Position = UDim2.new(nPos.X.Scale, nPos.X.Offset, nPos.Y.Scale, nPos.Y.Offset + 65)
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

--------------------------------------------------
-- TITLE & SUBTITLE (AYNI KALDI)
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
sub.Text = "forsaken"
sub.TextColor3 = Color3.fromRGB(0, 120, 0)
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
    Instance.new("UIStroke", b).Color = Color3.fromRGB(30, 30, 30)
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
-- ULTRA UPGRADE CORE (NO-DEATH BYPASS)
--------------------------------------------------
RunService.Stepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
        local hrp = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        -- HIZ (DOKUNULMADI)
        if hyperActive and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * hyperMultiplier)
        end
        
        -- ULTRA KORUMA
        if antiAttackActive then
            -- Canı milisaniyelik 100'e kilitler (Sunucu paketini beklemez)
            if hum.Health < 100 then hum.Health = 100 end
            
            -- ÖLÜMÜN TÜM YOLLARINI KAPATIR
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false) -- Darbe etkisini azaltır
            
            -- Anti-Void Upgrade
            if hrp.Position.Y < -30 then
                hrp.Velocity = Vector3.new(0, 0, 0)
                hrp.CFrame = CFrame.new(hrp.Position.X, 20, hrp.Position.Z)
            end
            
            -- Katilin Karakterini ve Objeleri "Dokunulmaz" Yapar (Gelişmiş)
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanTouch = false -- Senin parçaların hasar algılamasın
                end
            end
        else
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") then v.CanTouch = true end
            end
        end
    end
end)

--------------------------------------------------
-- TOGGLE & LOGO ANIMATION (BEYAZLIKSIZ YEŞİL)
--------------------------------------------------
btn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
    if menu.Visible then
        TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 255, 0), Thickness = 4}):Play()
        TweenService:Create(btn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(0, 255, 0)}):Play()
    else
        TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 100, 0), Thickness = 2}):Play()
        TweenService:Create(btn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(0, 200, 0)}):Play()
    end
end)
