-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local hyperActive = false
local hyperMultiplier = 50 -- Anti-cheat dostu yüksek hız çarpanı

-- GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_FORSAKEN_HYPER"

--------------------------------------------------
-- LOGO & DRAG SYSTEM
--------------------------------------------------
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(55, 55)
btn.Position = UDim2.new(0, 30, 0, 30)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
btn.TextColor3 = Color3.fromRGB(0, 255, 120)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 22
btn.AutoButtonColor = false

local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 120, 60)
btnStroke.Thickness = 2
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(220, 280)
menu.Position = UDim2.new(0, 30, 0, 95)
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", menu).Color = Color3.fromRGB(0, 120, 60)

-- DRAG (Sadece Logoyu Tutarak Taşıma)
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
-- HEADER (FORSAKEN GOTHAM BLACK)
--------------------------------------------------
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "GREENHUB"
title.TextColor3 = Color3.fromRGB(0, 255, 120)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local sub = Instance.new("TextLabel", menu)
sub.Size = UDim2.new(1, 0, 0, 15)
sub.Position = UDim2.new(0, 0, 0, 30)
sub.BackgroundTransparency = 1
sub.Text = "forsaken"
sub.TextColor3 = Color3.fromRGB(0, 150, 80)
sub.Font = Enum.Font.GothamBlack -- İstediğin Font
sub.TextSize = 13

--------------------------------------------------
-- HYPER SPEED SYSTEM (ANTI-CHEAT SAFE)
--------------------------------------------------
local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -16, 1, -80)
scroll.Position = UDim2.new(0, 8, 0, 65)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 6)

local function createButton(text, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    b.TextColor3 = Color3.fromRGB(0, 255, 120)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", b).Color = Color3.fromRGB(40, 40, 40)
    b.MouseButton1Click:Connect(function() callback(b) end)
    return b
end

createButton("Hyper Speed: OFF", function(self)
    hyperActive = not hyperActive
    if hyperActive then
        self.Text = "Hyper Speed: ON"
        self.TextColor3 = Color3.fromRGB(255, 255, 255)
        self.BackgroundColor3 = Color3.fromRGB(0, 80, 40)
    else
        self.Text = "Hyper Speed: OFF"
        self.TextColor3 = Color3.fromRGB(0, 255, 120)
        self.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    end
end)

-- ANTI-CHEAT DOSTU HAREKET DÖNGÜSÜ
RunService.RenderStepped:Connect(function()
    if hyperActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local hum = player.Character.Humanoid
        
        if hum.MoveDirection.Magnitude > 0 then
            -- WalkSpeed'e dokunmadan CFrame üzerinden çok hızlı pozisyon güncellemesi
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * hyperMultiplier)
        end
    end
end)

--------------------------------------------------
-- TOGGLE & ANIMATION
--------------------------------------------------
btn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
    if menu.Visible then
        TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 255, 120), Thickness = 3}):Play()
        btn.TextColor3 = Color3.fromRGB(255, 255, 255) -- Aktifken parlama
    else
        TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 120, 60), Thickness = 2}):Play()
        btn.TextColor3 = Color3.fromRGB(0, 255, 120)
    end
end)
