-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local boosting = false
local speedActive = false

-- GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_FINAL_FIX"

--------------------------------------------------
-- LOGO & DRAG SYSTEM
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

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(220, 280) -- Boyut biraz büyütüldü başlıklar için
menu.Position = UDim2.new(0, 30, 0, 95)
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", menu).Color = Color3.fromRGB(0, 120, 60)

-- DRAG LOGIC
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
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

--------------------------------------------------
-- TITLE & SUBTITLE (EKLEDİM!)
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
sub.TextColor3 = Color3.fromRGB(0, 120, 60)
sub.Font = Enum.Font.GothamMedium
sub.TextSize = 11

--------------------------------------------------
-- SCROLL & BUTTON CREATOR
--------------------------------------------------
local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -16, 1, -70)
scroll.Position = UDim2.new(0, 8, 0, 60)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 6)

local function createButton(text, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    b.TextColor3 = Color3.fromRGB(0, 200, 100)
    b.Font = Enum.Font.Gotham
    b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", b).Color = Color3.fromRGB(35, 35, 35)
    
    b.MouseButton1Click:Connect(function()
        callback(b) -- Butonun kendisini callback'e gönderiyoruz
    end)
    return b
end

--------------------------------------------------
-- FEATURES (FIXED!)
--------------------------------------------------
createButton("Turbo Speed: OFF", function(self)
    speedActive = not speedActive
    if speedActive then
        boosting = true
        self.Text = "Turbo Speed: ON"
        self.TextColor3 = Color3.fromRGB(255, 255, 255)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 700
        end
    else
        boosting = false
        self.Text = "Turbo Speed: OFF"
        self.TextColor3 = Color3.fromRGB(0, 200, 100)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

createButton("Toggle Chat", function()
    local chatGui = player.PlayerGui:FindFirstChild("Chat")
    if chatGui then chatGui.Enabled = not chatGui.Enabled end
end)

-- Boost Loop
RunService.RenderStepped:Connect(function()
    if boosting and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local hum = player.Character.Humanoid
        if hum.MoveDirection.Magnitude > 0 then
            hrp.Velocity = hrp.Velocity + (hum.MoveDirection * 1.5)
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
    else
        TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 120, 60), Thickness = 2}):Play()
    end
end)
