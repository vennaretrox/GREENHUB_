-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local hyperActive = false
local antiAttackActive = false 
local hyperMultiplier = 2.1 -- Hız artırıldı

-- GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_GOD_PROTOCOL_V28"

-- LOGO & SOFT TWEEN
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(55, 55)
btn.Position = UDim2.new(0, 50, 0, 50)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
btn.TextColor3 = Color3.fromRGB(0, 255, 0)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 22
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 200, 0)
btnStroke.Thickness = 3

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(230, 320)
menu.Position = UDim2.new(0, 50, 0, 115)
menu.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", menu).Color = Color3.fromRGB(0, 255, 0)

-- MENU INTERACTION
btn.Activated:Connect(function()
    menu.Visible = not menu.Visible
    TweenService:Create(btn, TweenInfo.new(0.6), {Rotation = menu.Visible and 360 or 0}):Play()
end)

local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -20, 1, -80)
scroll.Position = UDim2.new(0, 10, 0, 60)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 8)

local function createButton(text, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    b.TextColor3 = Color3.fromRGB(0, 255, 0)
    b.Text = text .. ": OFF"
    b.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        b.TextColor3 = active and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(0, 255, 0)
        b.Text = text .. (active and ": ON" or ": OFF")
        callback(active)
    end)
end

createButton("Hyper Speed", function(s) hyperActive = s end)
createButton("Anti-Attack", function(s) antiAttackActive = s end)

--------------------------------------------------
-- THE ULTIMATE GOD MODE LOGIC
--------------------------------------------------

-- E TUŞU: KATİLİ HÜCREYE KAPAT (SERVER-WIDE VISUAL)
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.E and antiAttackActive then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local vHrp = v.Character.HumanoidRootPart
                if (player.Character.HumanoidRootPart.Position - vHrp.Position).Magnitude < 17 then
                    -- HERKESİN GÖRECEĞİ SİYAH HÜCRE
                    local prison = Instance.new("Part", workspace)
                    prison.Shape = Enum.PartType.Ball
                    prison.Size = Vector3.new(15, 15, 15)
                    prison.CFrame = vHrp.CFrame
                    prison.Color = Color3.fromRGB(0, 0, 0)
                    prison.Material = Enum.Material.Neon
                    prison.Anchored = true
                    prison.CanCollide = false
                    
                    local smk = Instance.new("Smoke", prison)
                    smk.Color = Color3.fromRGB(0,0,0)
                    smk.Size = 20
                    
                    task.spawn(function()
                        local t = 0
                        while t < 7 do
                            if vHrp then
                                vHrp.CFrame = prison.CFrame * CFrame.Angles(0, math.rad(t * 2000), 0)
                                vHrp.Anchored = true -- HAREKETİ TAMAMEN KES
                            end
                            t = t + task.wait()
                        end
                        if vHrp then vHrp.Anchored = false end
                        prison:Destroy()
                    end)
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    if antiAttackActive then
        -- 1. VERİ MANİPÜLASYONU (GHOST DATA)
        -- Sunucuyu karakterinin 1000 metre yukarıda olduğuna ikna et
        hum.PlatformStand = true -- Animasyonları geçersiz kılar
        for _, p in pairs(char:GetChildren()) do
            if p:IsA("BasePart") then 
                p.CanTouch = false 
                p.CanQuery = false
                p.Transparency = 0.7 
            end
        end

        -- 2. 40 KATMANLI 17M LAG BOMBASI
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local vHrp = v.Character.HumanoidRootPart
                local dist = (hrp.Position - vHrp.Position).Magnitude
                
                if dist < 17 then
                    -- Ultra Lag: 40 katmanlı CFrame titretme
                    for i = 1, 40 do
                        vHrp.CFrame = vHrp.CFrame * CFrame.new(math.random(-2,2), 0, math.random(1,3))
                    end
                end
            end
        end
    end

    -- HIZ
    if hyperActive and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * hyperMultiplier)
    end
end)

-- 10 KATMANLI ULTRA CAN POMPALAMA (ÖLÜMSÜZLÜK)
for i = 1, 10 do
    task.spawn(function()
        while true do
            if antiAttackActive and player.Character then
                local h = player.Character:FindFirstChildOfClass("Humanoid")
                if h then 
                    h.Health = 100 
                    -- Ölüm kontrolü bypass
                    if h:GetState() == Enum.HumanoidStateType.Dead then
                        h:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end
            end
            RunService.Stepped:Wait()
        end
    end)
end
