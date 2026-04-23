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

-- [FORSAKEN DESIGN V91]
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_V91_LOGO_FOCUS"

-- LOGO (KISA G H & KOYU KENARLIK)
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(55, 55)
btn.Position = UDim2.new(0, 100, 0, 100)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
btn.TextColor3 = Color3.fromRGB(0, 255, 0)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 18 
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

-- YAZI ETRAFI KOYU YEŞİL
local textStroke = Instance.new("UIStroke", btn)
textStroke.Color = Color3.fromRGB(0, 30, 0) 
textStroke.Thickness = 2.5
textStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual

-- İSTEDİĞİN O YAVAŞ PARLAMA (GLOW)
local glow = Instance.new("UIStroke", btn)
glow.Color = Color3.fromRGB(0, 255, 0)
glow.Thickness = 0
glow.Transparency = 1 -- Başlangıçta görünmez

-- MENÜ (HIZLI AÇILIR)
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(250, 350)
menu.Position = UDim2.new(0, 100, 0, 165)
menu.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", menu).Color = Color3.fromRGB(0, 255, 0)

-- [SADECE LOGO PARLAMA ANİMASYONU]
local function animateLogoGlow(open)
    -- Parlamanın yavaşça sönmesi/yanması için 1.2 saniyelik süre
    local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    if open then
        -- Menü açılınca logo yavaşça parlar
        TweenService:Create(glow, tweenInfo, {Thickness = 5, Transparency = 0.3}):Play()
    else
        -- Menü kapanınca logo parlaması yavaşça gider
        TweenService:Create(glow, tweenInfo, {Thickness = 0, Transparency = 1}):Play()
    end
end

-- DRAG
local dragging, dragStart, startPos
btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = btn.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        menu.Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset, btn.Position.Y.Scale, btn.Position.Y.Offset + 65)
    end
end)
UIS.InputEnded:Connect(function(input) dragging = false end)

btn.Activated:Connect(function()
    menu.Visible = not menu.Visible
    animateLogoGlow(menu.Visible)
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

-- [SENİN AUTO GENERATOR KODUN]
createButton("Auto Generator", function(s) 
    autoGenActive = s
    if s then
        task.spawn(function()
            while autoGenActive do
                pcall(function()
                    if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame") and workspace.Map.Ingame:FindFirstChild("Map") then
                        for _, generator in pairs(workspace.Map.Ingame.Map:GetChildren()) do
                            if generator.Name == "Generator" and generator:FindFirstChild("Remotes") and generator.Remotes:FindFirstChild("RE") then
                                generator.Remotes.RE:FireServer()
                            end
                        end
                    end
                end)
                task.wait(3.5)
            end
        end)
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
