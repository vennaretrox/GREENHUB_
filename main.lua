-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local boosting = false -- Arkadan itiş kontrolü

-- GUI CONTAINER
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_HYPER"

--------------------------------------------------
-- LOGO & DRAG SYSTEM (Stabilize Edildi)
--------------------------------------------------
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(55, 55)
btn.Position = UDim2.new(0, 30, 0, 30)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
btn.TextColor3 = Color3.fromRGB(0, 255, 120)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 22

Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 120, 60)
btnStroke.Thickness = 2

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(220, 250)
menu.Position = UDim2.new(0, 30, 0, 95)
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Visible = false

Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", menu).Color = Color3.fromRGB(0, 120, 60)

-- Sürükleme Mantığı
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
-- ARKADAN İTİŞ (THRUST) SİSTEMİ
--------------------------------------------------
RunService.RenderStepped:Connect(function()
    if boosting and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local hum = player.Character.Humanoid
        
        -- Eğer hareket ediyorsa arkadan ekstra kuvvet uygula
        if hum.MoveDirection.Magnitude > 0 then
            hrp.Velocity = hrp.Velocity + (hum.MoveDirection * 20) -- İvme kazandırır
        end
    end
end)

--------------------------------------------------
-- BUTTONS & SCROLL
--------------------------------------------------
local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -16, 1, -20)
scroll.Position = UDim2.new(0, 8, 0, 10)
scroll.BackgroundTransparency = 1
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 6)

local function createButton(text, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    b.TextColor3 = Color3.fromRGB(0, 200, 100)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(callback)
    return b
end

createButton("HYPER SPEED: 700", function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 1000
        boosting = true -- İtişi açar
    end
end)

createButton("Stop Boost", function()
    boosting = false
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
    end
end)

--------------------------------------------------
-- TOGGLE
--------------------------------------------------
btn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)
