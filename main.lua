-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local hyperActive = false

-- GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_ORIGINAL_RETURN"

--------------------------------------------------
-- LOGO BUTTON (G H) - ESKİ TASARIM VE DRAG
--------------------------------------------------
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(55, 55)
btn.Position = UDim2.new(0, 30, 0, 30)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
btn.TextColor3 = Color3.fromRGB(0, 255, 120)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 22

local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 120, 60)
btnStroke.Thickness = 2
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

-- Menü
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(220, 320) -- Eski büyük menü boyutu
menu.Position = UDim2.new(0, 30, 0, 95)
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", menu).Color = Color3.fromRGB(0, 120, 60)

--------------------------------------------------
-- DRAG SYSTEM (LOGOYA ÖZEL)
--------------------------------------------------
local dragging, dragStart, startPos
btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = btn.Position
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
-- TITLE & FORSAKEN (GOTHAM BLACK)
--------------------------------------------------
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "GREENHUB"
title.TextColor3 = Color3.fromRGB(0, 255, 120)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local sub = Instance.new("TextLabel", menu)
sub.Size = UDim2.new(1, 0, 0, 20)
sub.Position = UDim2.new(0, 0, 0, 35)
sub.BackgroundTransparency = 1
sub.Text = "forsaken"
sub.TextColor3 = Color3.fromRGB(0, 120, 60)
sub.Font = Enum.Font.GothamBlack
sub.TextSize = 14

--------------------------------------------------
-- SPEED SYSTEM (ESKİ SERTLİKTE)
--------------------------------------------------
local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -10, 1, -70)
scroll.Position = UDim2.new(0, 5, 0, 65)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 6)

local function createButton(text, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    b.TextColor3 = Color3.fromRGB(0, 255, 120)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function() callback(b) end)
    return b
end

createButton("Hyper Speed: OFF", function(self)
    hyperActive = not hyperActive
    if hyperActive then
        self.Text = "Hyper Speed: ON"
        self.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        self.Text = "Hyper Speed: OFF"
        self.TextColor3 = Color3.fromRGB(0, 255, 120)
    end
end)

-- HIZ DÖNGÜSÜ (ASIL HIZ)
RunService.RenderStepped:Connect(function()
    if hyperActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local hum = player.Character.Humanoid
        if hum.MoveDirection.Magnitude > 0 then
            -- 1000 Hızın asıl hissi buradaki çarpandadır
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * 1.5) 
        end
    end
end)

--------------------------------------------------
-- ESKİ LOGO ANİMASYONU (AÇ/KAPAT)
--------------------------------------------------
btn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
    
    if menu.Visible then
        -- AYDINLIK EFEKTİ
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(25, 25, 25), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 255, 120), Thickness = 3}):Play()
    else
        -- NORMAL EFEKT
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(10, 10, 10), TextColor3 = Color3.fromRGB(0, 255, 120)}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 120, 60), Thickness = 2}):Play()
    end
end)
