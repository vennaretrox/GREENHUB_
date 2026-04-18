-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local hyperActive = false

-- GUI CONTAINER
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_ULTRA_FORSAKEN"

--------------------------------------------------
-- LOGO & DRAG (ESKİ STİL + AYRILMIŞ G H)
--------------------------------------------------
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(55, 55)
btn.Position = UDim2.new(0, 30, 0, 30)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
btn.TextColor3 = Color3.fromRGB(0, 255, 120)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 22
btn.AutoButtonColor = false

local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 120, 60)
btnStroke.Thickness = 2
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

-- Menü (Eski Görünüm)
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(230, 300)
menu.Position = UDim2.new(0, 30, 0, 100)
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", menu).Color = Color3.fromRGB(0, 120, 60)

-- Sürükleme (Logoya Özel)
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
        menu.Position = UDim2.new(nPos.X.Scale, nPos.X.Offset, nPos.Y.Scale, nPos.Y.Offset + 70)
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

--------------------------------------------------
-- BAŞLIKLAR (GOTHAM BLACK)
--------------------------------------------------
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "GREENHUB"
title.TextColor3 = Color3.fromRGB(0, 255, 120)
title.Font = Enum.Font.GothamBold
title.TextSize = 22

local sub = Instance.new("TextLabel", menu)
sub.Size = UDim2.new(1, 0, 0, 20)
sub.Position = UDim2.new(0, 0, 0, 38)
sub.BackgroundTransparency = 1
sub.Text = "forsaken"
sub.TextColor3 = Color3.fromRGB(0, 150, 80)
sub.Font = Enum.Font.GothamBlack
sub.TextSize = 14

--------------------------------------------------
-- SÜPER HIZ SİSTEMİ (CFRAME OVERDRIVE)
--------------------------------------------------
local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -20, 1, -85)
scroll.Position = UDim2.new(0, 10, 0, 75)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 8)

local function createButton(text, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    b.TextColor3 = Color3.fromRGB(0, 255, 120)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 15
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", b).Color = Color3.fromRGB(40, 40, 40)
    b.MouseButton1Click:Connect(function() callback(b) end)
    return b
end

createButton("Hyper Speed: OFF", function(self)
    hyperActive = not hyperActive
    if hyperActive then
        self.Text = "Hyper Speed: ON"
        self.TextColor3 = Color3.fromRGB(255, 255, 255)
        self.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
    else
        self.Text = "Hyper Speed: OFF"
        self.TextColor3 = Color3.fromRGB(0, 255, 120)
        self.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    end
end)

-- ASIL HIZ DÖNGÜSÜ (DURDURULAMAZ HIZ)
RunService.RenderStepped:Connect(function()
    if hyperActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local hum = player.Character.Humanoid
        if hum.MoveDirection.Magnitude > 0 then
            -- Bu çarpan seni mermi gibi fırlatacak
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * 15) 
        end
    end
end)

--------------------------------------------------
-- LOGO ANİMASYONU (AYDINLIK EFEKTİ - GERİ GELDİ)
--------------------------------------------------
btn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
    
    if menu.Visible then
        -- Menü açılırken aydınlanan logo
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 30), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 255, 150), Thickness = 4}):Play()
    else
        -- Kapanırken eski haline dönen logo
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(10, 10, 10), TextColor3 = Color3.fromRGB(0, 255, 120)}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 120, 60), Thickness = 2}):Play()
    end
end)
