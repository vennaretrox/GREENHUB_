-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local hyperActive = false
local autoGenActive = false
local hyperMultiplier = 2.1

-- [FORSAKEN DESIGN SYSTEM - V78]
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_V78"

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(65, 65)
btn.Position = UDim2.new(0, 50, 0, 50)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
btn.TextColor3 = Color3.fromRGB(0, 255, 0)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 26 -- Daha kalın yazı
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 15)

-- LOGO KENAR PARLAMASI (YANLAR KOYU)
local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Thickness = 4.5
btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
btnStroke.Transparency = 1 -- Başlangıçta gizli

local strokeGradient = Instance.new("UIGradient", btnStroke)
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 30, 0)), -- Yanlar Koyu
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)), -- Orta Parlak
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 30, 0))  -- Yanlar Koyu
})

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(250, 350)
menu.Position = UDim2.new(0, 50, 0, 130)
menu.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", menu).Color = Color3.fromRGB(0, 255, 0)

-- SMART GLOW ANIMATION
local function toggleGlow(isOpen)
    local info = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    if isOpen then
        TweenService:Create(btnStroke, info, {Transparency = 0}):Play()
    else
        TweenService:Create(btnStroke, info, {Transparency = 1}):Play()
    end
end

btn.Activated:Connect(function()
    menu.Visible = not menu.Visible
    toggleGlow(menu.Visible)
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
sub.Text = "forsaken"
sub.TextColor3 = Color3.fromRGB(0, 120, 0)
sub.Font = Enum.Font.GothamBlack
sub.TextSize = 16

-- DRAG
local dragging, dragStart, startPos
btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = btn.Position end end)
UIS.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) menu.Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset, btn.Position.Y.Scale, btn.Position.Y.Offset + 80) end end)
UIS.InputEnded:Connect(function(input) dragging = false end)

local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -20, 1, -120)
scroll.Position = UDim2.new(0, 10, 0, 100)
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
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        b.Text = text .. (active and ": ON" or ": OFF")
        b.TextColor3 = active and Color3.fromRGB(130, 0, 200) or Color3.fromRGB(0, 255, 0)
        callback(active)
    end)
end

createButton("Hyper Speed", function(s) hyperActive = s end)
createButton("Auto Generator", function(s) autoGenActive = s end)

--------------------------------------------------
-- ASIL JENERATÖR KODU (LINKTEKİ MANTIK)
--------------------------------------------------

task.spawn(function()
    while task.wait(0.1) do
        if autoGenActive then
            pcall(function()
                -- Oyunun jeneratör puzzle klasörünü ve sinyalini hedefliyoruz
                local mainRemote = ReplicatedStorage:FindFirstChild("MainEvent") or ReplicatedStorage:FindFirstChild("RemoteEvent")
                
                -- Puzzle ekranı her açıldığında oyuna "Tamam" sinyali gönderir
                for _, g in pairs(player.PlayerGui:GetChildren()) do
                    if g.Name:find("Puzzle") or g.Name:find("Gen") then
                        -- Bu kısım o linkteki gizli tetikleyicidir:
                        if mainRemote then
                            mainRemote:FireServer("FinishedPuzzle", true)
                            mainRemote:FireServer("GeneratorRepair", "Success")
                        end
                    end
                end
            end)
        end
    end
end)

-- SPEED LOOP
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = player.Character
        if char and hyperActive then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * hyperMultiplier)
            end
        end
    end)
end)
