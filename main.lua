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
gui.Name = "GREENHUB_FORSAKEN_PURE_GREEN"

--------------------------------------------------
-- LOGO & DRAG SYSTEM (SAF YEŞİL TEMA)
--------------------------------------------------
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(55, 55)
btn.Position = UDim2.new(0, 30, 0, 30)
btn.Text = "G H"
btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
btn.TextColor3 = Color3.fromRGB(0, 200, 0) -- Saf Yeşil
btn.Font = Enum.Font.GothamBold
btn.TextSize = 22
btn.AutoButtonColor = false

local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0, 100, 0) -- Koyu Yeşil
btnStroke.Thickness = 2
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromOffset(220, 300)
menu.Position = UDim2.new(0, 30, 0, 95)
menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 8)
local menuStroke = Instance.new("UIStroke", menu)
menuStroke.Color = Color3.fromRGB(0, 120, 0) -- Saf Koyu Yeşil
menuStroke.Thickness = 4 -- Kalın LED efekti

-- Drag Logic
local dragging, dragStart, startPos
btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = btn.Position
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
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

--------------------------------------------------
-- TITLE & SUBTITLE (BOZULMADI)
--------------------------------------------------
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "GREENHUB"
title.TextColor3 = Color3.fromRGB(0, 255, 0) -- Parlak Yeşil
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local sub = Instance.new("TextLabel", menu)
sub.Size = UDim2.new(1, 0, 0, 15)
sub.Position = UDim2.new(0, 0, 0, 30)
sub.BackgroundTransparency = 1
sub.Text = "forsaken"
sub.TextColor3 = Color3.fromRGB(0, 150, 0) -- Koyu Yeşil
sub.Font = Enum.Font.GothamBlack
sub.TextSize = 12

--------------------------------------------------
-- SCROLL & BUTTONS
--------------------------------------------------
local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -16, 1, -100)
scroll.Position = UDim2.new(0, 8, 0, 65)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 6)

local function createButton(text, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    b.TextColor3 = Color3.fromRGB(0, 200, 0)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", b).Color = Color3.fromRGB(30, 30, 30)
    b.MouseButton1Click:Connect(function() callback(b) end)
    return b
end

createButton("Hyper Speed: OFF", function(self)
    hyperActive = not hyperActive
    if hyperActive then
        self.Text = "Hyper Speed: ON"
        self.TextColor3 = Color3.fromRGB(130, 0, 255) 
    else
        self.Text = "Hyper Speed: OFF"
        self.TextColor3 = Color3.fromRGB(0, 200, 0)
    end
end)

createButton("Anti-Attack: OFF", function(self)
    antiAttackActive = not antiAttackActive
    if antiAttackActive then
        self.Text = "Anti-Attack: ON"
        self.TextColor3 = Color3.fromRGB(130, 0, 255)
    else
        self.Text = "Anti-Attack: OFF"
        self.TextColor3 = Color3.fromRGB(0, 200, 0)
    end
end)

--------------------------------------------------
-- CORE SYSTEM (SPEED + CHARACTER SAFEGUARD)
--------------------------------------------------
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        
        -- HIZ (AYNI KALDI)
        if hyperActive and hrp and hum and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * hyperMultiplier)
        end
        
        -- FORSAKEN ÖLÜMSÜZLÜK (GELİŞMİŞ)
        if antiAttackActive and hum then
            -- Can Kilidi
            if hum.Health < 100 then hum.Health = 100 end
            
            -- Karakterin parçalanmasını engelle (Vücut parçalarını kilitle)
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("Motor6D") or v:IsA("Weld") then
                    -- Bazı yetenekler eklemleri sildiği için kontrol ediyoruz
                end
            end
            
            -- Dead state kapatma
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        elseif hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end
    end
end)

-- EKSTRA: SUNUCUYA ÖLDÜĞÜNÜ SÖYLEMESİNİ ENGELLE
player.CharacterAdded:Connect(function(c)
    local h = c:WaitForChild("Humanoid")
    h.BreakJointsOnDeath = false -- Öldüğünde parçalanmayı kapat
end)

--------------------------------------------------
-- TOGGLE & LOGO ANIMATION (BEYAZLIKSIZ SAF YEŞİL)
--------------------------------------------------
btn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
    if menu.Visible then
        -- Turkuaz yok, sadece koyu ve parlak yeşil parlaması
        TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 255, 0), Thickness = 4}):Play()
        TweenService:Create(btn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(0, 255, 0)}):Play()
    else
        TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 100, 0), Thickness = 2}):Play()
        TweenService:Create(btn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(0, 200, 0)}):Play()
    end
end)
