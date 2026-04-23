-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local hyperActive = false
local autoGenActive = false
local hyperMultiplier = 2.1

-- [V85 - GHOST ENGINE & SMOOTH UI]
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_V85"

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(55, 55)
btn.Position = UDim2.new(0, 50, 0, 50)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
btn.TextColor3 = Color3.fromRGB(0, 255, 0)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 18 
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

-- YAZI ETRAFI KOYU YEŞİL
local textStroke = Instance.new("UIStroke", btn)
textStroke.Color = Color3.fromRGB(0, 40, 0) 
textStroke.Thickness = 2
textStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual

-- YAVAŞ PARILTI SİSTEMİ
local glow = Instance.new("UIStroke", btn)
glow.Color = Color3.fromRGB(0, 255, 0)
glow.Thickness = 0
glow.Transparency = 1

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(250, 350)
menu.Position = UDim2.new(0, 50, 0, 115)
menu.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
menu.BackgroundTransparency = 1 -- Başlangıçta görünmez
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
local mStroke = Instance.new("UIStroke", menu)
mStroke.Color = Color3.fromRGB(0, 255, 0)
mStroke.Transparency = 1

-- YAVAŞ AÇILIŞ/KAPANIŞ ANİMASYONU
local function toggleMenu(open)
    local info = TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    if open then
        menu.Visible = true
        TweenService:Create(menu, info, {BackgroundTransparency = 0}):Play()
        TweenService:Create(mStroke, info, {Transparency = 0}):Play()
        TweenService:Create(glow, info, {Thickness = 4, Transparency = 0.4}):Play()
    else
        TweenService:Create(menu, info, {BackgroundTransparency = 1}):Play()
        TweenService:Create(mStroke, info, {Transparency = 1}):Play()
        TweenService:Create(glow, info, {Thickness = 0, Transparency = 1}):Play()
        task.delay(1.2, function() if not autoGenActive then menu.Visible = false end end)
    end
end

btn.Activated:Connect(function()
    menu.Visible = not menu.Visible
    toggleMenu(menu.Visible)
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

-- DRAG & LIST LAYOUT (HIZLI GEÇİLDİ)
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

-- GHOST AUTO-GENERATOR (LUNIX INVISIBLE)
createButton("Auto Generator", function(s) 
    autoGenActive = s
    if s then
        -- Arka planda Lunix'i çalıştır
        task.spawn(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Dzgak/xrurus/refs/heads/main/farsaken.lua"))()
        end)
        
        -- TÜM RAYFIELD UI'LARINI ANINDA YOK ET (GÖRÜNMEZ YAP)
        task.spawn(function()
            while autoGenActive do
                for _, v in pairs(CoreGui:GetChildren()) do
                    if v.Name:find("Rayfield") or v:FindFirstChild("Main") then
                        v.Enabled = false -- Menüyü gizle ama kodun çalışmasına izin ver
                    end
                end
                for _, v in pairs(player.PlayerGui:GetChildren()) do
                    if v.Name:find("Rayfield") then v.Enabled = false end
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- SPEED LOOP (2.1x)
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
