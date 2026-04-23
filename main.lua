-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local hyperActive = false
local instantGenActive = false -- Yeni İsim
local hyperMultiplier = 2.1

-- [FORSAKEN V74 - INSTANT COMPLETION]
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_V74_INSTANT"

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(60, 60)
btn.Position = UDim2.new(0, 50, 0, 50)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
btn.TextColor3 = Color3.fromRGB(0, 255, 0)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 22
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 255, 0)
btnStroke.Thickness = 2
btnStroke.Transparency = 1 

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 250, 0, 350)
menu.Position = UDim2.new(0, 50, 0, 120)
menu.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", menu).Color = Color3.fromRGB(0, 255, 0)

-- SMART GLOW
btn.Activated:Connect(function()
    menu.Visible = not menu.Visible
    TweenService:Create(btnStroke, TweenInfo.new(0.8), {Transparency = menu.Visible and 0 or 1}):Play()
end)

-- BAŞLIKLAR
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
sub.Text = "forsaken "
sub.TextColor3 = Color3.fromRGB(0, 120, 0)
sub.Font = Enum.Font.GothamBlack
sub.TextSize = 14

-- DRAG & BUTTONS
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
    b.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    b.TextColor3 = Color3.fromRGB(0, 255, 0)
    b.Text = text .. ": OFF"
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function()
        callback(b)
    end)
end

createButton("Hyper Speed", function(b) 
    hyperActive = not hyperActive
    b.Text = "Hyper Speed: " .. (hyperActive and "ON" or "OFF")
    b.TextColor3 = hyperActive and Color3.fromRGB(130, 0, 200) or Color3.fromRGB(0, 255, 0)
end)

createButton("Instant Gen", function(b)
    instantGenActive = not instantGenActive
    b.Text = "Instant Gen: " .. (instantGenActive and "ON" or "OFF")
    b.TextColor3 = instantGenActive and Color3.fromRGB(130, 0, 200) or Color3.fromRGB(0, 255, 0)
end)

--------------------------------------------------
-- BYPASS CORE (SERVER-SIDE TRIGGER)
--------------------------------------------------

RunService.Heartbeat:Connect(function()
    if instantGenActive then
        -- Forsaken'daki jeneratör eventlerini yakalamak için global tarama
        for _, remote in pairs(game:GetDescendants()) do
            if remote:IsA("RemoteEvent") and (remote.Name:lower():find("gen") or remote.Name:lower():find("repair")) then
                -- Jeneratör eventini tetikle (Başarı Sinyali)
                remote:FireServer("Complete") 
                task.wait(1) -- Spam olmasın diye bekle
            end
        end
    end

    if hyperActive then
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * hyperMultiplier)
        end
    end
end)
