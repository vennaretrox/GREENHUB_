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

-- [FORSAKEN DESIGN V79 - THE MASTERPIECE]
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_V79"

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(60, 60)
btn.Position = UDim2.new(0, 50, 0, 50)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
btn.TextColor3 = Color3.fromRGB(0, 255, 0)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 22
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

-- İNCE KOYU YEŞİL KENARLIK (LOGO DETAYI)
local innerStroke = Instance.new("UIStroke", btn)
innerStroke.Color = Color3.fromRGB(0, 40, 0) -- Çok ince koyu yeşil
innerStroke.Thickness = 1.5
innerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- DIŞ PARLAMA (SLOW GLOW)
local outerGlow = Instance.new("UIStroke", btn)
outerGlow.Color = Color3.fromRGB(0, 255, 0)
outerGlow.Thickness = 0
outerGlow.Transparency = 1 -- Başlangıçta yok

-- PARLAMA ANİMASYON FONKSİYONU (YAVAŞÇA)
local function animateGlow(state)
    local info = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    if state then
        TweenService:Create(outerGlow, info, {Thickness = 5, Transparency = 0.3}):Play()
    else
        TweenService:Create(outerGlow, info, {Thickness = 0, Transparency = 1}):Play()
    end
end

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(250, 360)
menu.Position = UDim2.new(0, 50, 0, 120)
menu.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", menu).Color = Color3.fromRGB(0, 255, 0)

btn.Activated:Connect(function()
    menu.Visible = not menu.Visible
    animateGlow(menu.Visible)
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
sub.TextSize = 15

-- DRAG
local dragging, dragStart, startPos
btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = btn.Position end end)
UIS.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) menu.Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset, btn.Position.Y.Scale, btn.Position.Y.Offset + 70) end end)
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
-- LUNIX/RAYFIELD STYLE GEN SOLVER (V79)
--------------------------------------------------

task.spawn(function()
    while task.wait(0.2) do
        if autoGenActive then
            pcall(function()
                -- Jeneratör UI Klasörlerini kontrol et
                local pGui = player.PlayerGui
                local puzzleNames = {"Puzzle", "GeneratorUI", "Minigame", "Repair"}
                
                for _, name in pairs(puzzleNames) do
                    local activeUI = pGui:FindFirstChild(name)
                    if activeUI and activeUI.Enabled then
                        -- LUNIX MANTIĞI: Oyuna 'Puzzle Çözüldü' sinyalini gönder
                        local mainEvent = ReplicatedStorage:FindFirstChild("MainEvent") or ReplicatedStorage:FindFirstChild("RemoteEvent")
                        if mainEvent then
                            -- Tüm popüler Forsaken sinyallerini dene
                            mainEvent:FireServer("FinishedPuzzle", true)
                            mainEvent:FireServer("Generator", "Complete")
                        end
                        
                        -- Alternatif: UI içindeki 'Complete' butonunu bulup tetikle
                        for _, obj in pairs(activeUI:GetDescendants()) do
                            if obj:IsA("RemoteEvent") or obj:IsA("BindableEvent") then
                                obj:FireServer(true)
                            end
                        end
                    end
                end
            end)
        end
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
