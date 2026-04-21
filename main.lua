-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local hyperActive = false
local antiAttackActive = false 
local e_active = false
local hyperMultiplier = 2.1

-- GUI TASARIMI (DRAG SİSTEMİ EKLENDİ)
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_V63_GHOST"

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(60, 60)
btn.Position = UDim2.new(0, 50, 0, 50)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
btn.TextColor3 = Color3.fromRGB(0, 80, 0)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 22
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 40, 0)
btnStroke.Thickness = 2.5

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(250, 350)
menu.Position = UDim2.new(0, 50, 0, 120)
menu.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", menu).Color = Color3.fromRGB(0, 255, 0)

-- SÜRÜKLEME (DRAG) SİSTEMİ RE-ADDED
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
        btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        menu.Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset, btn.Position.Y.Scale, btn.Position.Y.Offset + 70)
    end
end)
UIS.InputEnded:Connect(function(input) dragging = false end)

btn.Activated:Connect(function() menu.Visible = not menu.Visible end)

local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -20, 1, -120)
scroll.Position = UDim2.new(0, 10, 0, 95)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 10)

local function createButton(text, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 50)
    b.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    b.TextColor3 = Color3.fromRGB(0, 255, 0)
    b.Text = text .. ": OFF"
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        b.Text = text .. (active and ": ON" or ": OFF")
        callback(active)
    end)
end

createButton("Hyper Speed", function(s) hyperActive = s end)
createButton("Anti-Attack", function(s) antiAttackActive = s end)

--------------------------------------------------
-- MASTER GHOST-HITBOX SYSTEM (V63)
--------------------------------------------------

local offset = Vector3.new(0, 50, 0) -- Hitbox 50 birim yukarıda

RunService.RenderStepped:Connect(function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    -- LEGACY SPEED
    if hyperActive and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * hyperMultiplier)
    end

    if antiAttackActive then
        hum.MaxHealth = 2000
        if hum.Health < 2000 then hum.Health = 2000 end
        
        -- GÖRÜNÜMÜ AŞAĞIDA TUT, HİTBOX'I YUKARI ÇIKAR
        for _, p in pairs(char:GetChildren()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
                if p.Name ~= "HumanoidRootPart" then
                    p.Transparency = 0.6
                    p.Color = Color3.fromRGB(0, 255, 0)
                    p.Material = Enum.Material.ForceField
                    -- Görüntü senkronizasyonu (Aşağıda kalması için)
                    -- Not: Tam offsetleme için Motor6D manipülasyonu gerekir ancak bu en hızlı yöntemdir.
                end
            end
        end
        
        -- E TUŞU LAG (RAKİPLERİ ETKİLER)
        if UIS:IsKeyDown(Enum.KeyCode.E) then
            for _, other in pairs(Players:GetPlayers()) do
                if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
                    local oHrp = other.Character.HumanoidRootPart
                    if (hrp.Position - oHrp.Position).Magnitude < 30 then
                        oHrp.CFrame = oHrp.CFrame * CFrame.new(0, 60, 1) * CFrame.Angles(0, math.rad(50), 0)
                    end
                end
            end
        end
    end
end)
