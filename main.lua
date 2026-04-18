-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local hyperActive = false
local antiAttackActive = false 
local hyperMultiplier = 1.8 

-- GUI CONTAINER
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GREENHUB_FIXED_ULTRA"

--------------------------------------------------
-- LOGO & FIX (AÇILMAMA HATASI ÇÖZÜLDÜ)
--------------------------------------------------
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(60, 60)
btn.Position = UDim2.new(0, 50, 0, 50)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
btn.TextColor3 = Color3.fromRGB(0, 200, 0)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 24
btn.ZIndex = 10 -- En üstte kalması için

local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 100, 0)
btnStroke.Thickness = 3
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 15)

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(230, 320)
menu.Position = UDim2.new(0, 50, 0, 120)
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
local menuStroke = Instance.new("UIStroke", menu)
menuStroke.Color = Color3.fromRGB(0, 150, 0)
menuStroke.Thickness = 4

-- BASİT VE HATASIZ DRAG
local function makeDraggable(obj, target)
	local dragging, dragInput, dragStart, startPos
	obj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true dragStart = input.Position startPos = obj.Position
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			target.Position = UDim2.new(obj.Position.X.Scale, obj.Position.X.Offset, obj.Position.Y.Scale, obj.Position.Y.Offset + 70)
		end
	end)
	UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end
makeDraggable(btn, menu)

-- TIKLAMA HATASI FİX (MouseButton1Click yerine InputEnded kullanıyoruz)
btn.Activated:Connect(function()
	menu.Visible = not menu.Visible
	btn.TextColor3 = menu.Visible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 200, 0)
	btnStroke.Color = menu.Visible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 100, 0)
end)

--------------------------------------------------
-- BUTTONS & DESIGN
--------------------------------------------------
local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -20, 1, -110)
scroll.Position = UDim2.new(0, 10, 0, 70)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 8)

local function createButton(text, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    b.TextColor3 = Color3.fromRGB(0, 200, 0)
    b.Text = text
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(40, 40, 40)
    b.MouseButton1Click:Connect(function() callback(b, s) end)
    return b
end

createButton("Hyper Speed: OFF", function(self, s)
    hyperActive = not hyperActive
    self.Text = hyperActive and "Hyper Speed: ON" or "Hyper Speed: OFF"
    self.TextColor3 = hyperActive and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(0, 200, 0)
    s.Color = hyperActive and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(40, 40, 40)
end)

createButton("Anti-Attack: OFF", function(self, s)
    antiAttackActive = not antiAttackActive
    self.Text = antiAttackActive and "Anti-Attack: ON" or "Anti-Attack: OFF"
    self.TextColor3 = antiAttackActive and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(0, 200, 0)
    s.Color = antiAttackActive and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(40, 40, 40)
end)

--------------------------------------------------
-- GORUNMEZ DUVAR + KATIL CEZALANDIRMA + CAN
--------------------------------------------------
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    -- HIZ SİSTEMİ (1.8)
    if hyperActive and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * hyperMultiplier)
    end

    if antiAttackActive then
        -- CAN POMPASI (BYPASSLI)
        if hum.Health < 100 then hum.Health = 100 end
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

        -- GÖRÜNMEZ DUVAR & KATİLİ YAVAŞLATMA
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local kHrp = v.Character.HumanoidRootPart
                local kHum = v.Character:FindFirstChildOfClass("Humanoid")
                local mesafe = (hrp.Position - kHrp.Position).Magnitude

                if mesafe < 9 then -- 9 Metre koruma alanı
                    -- DUVAR ETKİSİ (İtme)
                    local yon = (kHrp.Position - hrp.Position).Unit
                    kHrp.Velocity = yon * 45
                    
                    -- KATİL CEZALANDIRMA (Yavaşlatma ve Yetenek Kapama)
                    if kHum then
                        kHum.WalkSpeed = 3
                        task.delay(7, function() if kHum then kHum.WalkSpeed = 16 end end)
                    end
                end
            end
        end
    end
end)

-- ARKA PLAN CAN SPAM (GARANTİYE ALMAK İÇİN)
task.spawn(function()
    while task.wait(0.1) do
        if antiAttackActive and player.Character then
            local h = player.Character:FindFirstChildOfClass("Humanoid")
            if h and h.Health < 100 then h.Health = 100 end
        end
    end
end)
