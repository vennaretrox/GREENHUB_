-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VIM = game:GetService("VirtualInputManager") -- Gerçek tıklama servisi

local player = Players.LocalPlayer
local hyperActive = false
local autoGenActive = false
local hyperMultiplier = 2.1

-- [FORSAKEN DESIGN - V72]
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_V72_SMARTGEN"

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
menu.Size = UDim2.fromOffset(250, 350)
menu.Position = UDim2.new(0, 50, 0, 120)
menu.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", menu).Color = Color3.fromRGB(0, 255, 0)

-- SMART GLOW (Menü açılınca parlar)
btn.Activated:Connect(function()
    menu.Visible = not menu.Visible
    local info = TweenInfo.new(0.8)
    TweenService:Create(btnStroke, info, {Transparency = menu.Visible and 0 or 1, Thickness = menu.Visible and 4 or 2}):Play()
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
-- INTELLIGENT COLOR MATCHER (V72)
--------------------------------------------------

local function virtualClick(obj)
    local x = obj.AbsolutePosition.X + (obj.AbsoluteSize.X / 2)
    local y = obj.AbsolutePosition.Y + (obj.AbsoluteSize.Y / 2) + 36 -- Topbar offset
    VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

task.spawn(function()
    while task.wait(0.5) do
        if autoGenActive then
            pcall(function()
                local foundButtons = {}
                
                -- Jeneratör UI'sını derinlemesine tara
                for _, gui in pairs(player.PlayerGui:GetChildren()) do
                    if gui:IsA("ScreenGui") and gui.Enabled then
                        for _, btn in pairs(gui:GetDescendants()) do
                            if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and btn.Visible and btn.AbsoluteSize.X > 0 then
                                -- Butonun rengini anahtar olarak kaydet
                                local colorKey = tostring(btn.BackgroundColor3)
                                if not foundButtons[colorKey] then
                                    foundButtons[colorKey] = {}
                                end
                                table.insert(foundButtons[colorKey], btn)
                            end
                        end
                    end
                end
                
                -- Aynı renkteki butonları eşleştir ve tıkla
                for color, buttons in pairs(foundButtons) do
                    if #buttons >= 2 then
                        -- 3-7 saniye arası insan taklidi yaparak bekle
                        task.wait(math.random(1, 2)) 
                        virtualClick(buttons[1]) -- İlk renkli buton
                        task.wait(0.2)
                        virtualClick(buttons[2]) -- İkinci aynı renkli buton (EŞLEŞTİ!)
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
