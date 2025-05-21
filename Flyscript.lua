-- Services
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Player & Character
local player    = Players.LocalPlayer
local char      = player.Character or player.CharacterAdded:Wait()
local root      = char:WaitForChild("HumanoidRootPart")

-- Speed mapping
local speedMap = { [1]=50, [2]=100, [3]=200 }
local speedLevel = 1

-- GUI container
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name         = "AhmedFlyScript"
gui.ResetOnSpawn = false

-- Main draggable frame
local frame = Instance.new("Frame", gui)
frame.Name               = "Main"
frame.Size               = UDim2.new(0, 260, 0, 160)
frame.Position           = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3   = Color3.fromRGB(30,30,30)
frame.Active             = true
frame.Draggable          = true

-- Title Bar
local title = Instance.new("TextLabel", frame)
title.Size              = UDim2.new(1,0,0,24)
title.Position          = UDim2.new(0,0,0,0)
title.BackgroundColor3  = Color3.fromRGB(25,25,25)
title.Text              = "ahmed’s fly gui"
title.TextColor3        = Color3.new(1,1,1)
title.Font              = Enum.Font.GothamBold
title.TextSize          = 18

-- Close button
local close = Instance.new("TextButton", frame)
close.Size             = UDim2.new(0,24,0,24)
close.Position         = UDim2.new(1,-24,0,0)
close.BackgroundColor3 = Color3.fromRGB(200,50,50)
close.Text             = "X"
close.TextColor3       = Color3.new(1,1,1)
close.Font             = Enum.Font.GothamBold
close.TextSize         = 18

-- Reopen “F” button
local reopen = Instance.new("TextButton", gui)
reopen.Size             = UDim2.new(0,40,0,40)
reopen.Position         = UDim2.new(0,10,0,60)
reopen.BackgroundColor3 = Color3.fromRGB(80,80,80)
reopen.Text             = "F"
reopen.TextColor3       = Color3.new(1,1,1)
reopen.Font             = Enum.Font.GothamBold
reopen.TextSize         = 24
reopen.Visible          = false

-- Fly toggle
local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size             = UDim2.new(0.5,-15,0,36)
flyBtn.Position         = UDim2.new(0,10,0,30)
flyBtn.BackgroundColor3 = Color3.fromRGB(255,80,80)
flyBtn.Text             = "Fly: OFF"
flyBtn.TextColor3       = Color3.new(1,1,1)
flyBtn.Font             = Enum.Font.GothamBold
flyBtn.TextSize         = 16

-- Speed controls
local downBtn = Instance.new("TextButton", frame)
downBtn.Size             = UDim2.new(0,36,0,36)
downBtn.Position         = UDim2.new(0.5,5,0,30)
downBtn.BackgroundColor3 = Color3.fromRGB(150,100,200)
downBtn.Text             = "–"
downBtn.Font             = Enum.Font.GothamBold
downBtn.TextSize         = 24

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size            = UDim2.new(0,48,0,36)
speedLabel.Position        = UDim2.new(0.5,45,0,30)
speedLabel.BackgroundColor3= Color3.fromRGB(255,165,0)
speedLabel.Text             = tostring(speedLevel)
speedLabel.TextColor3       = Color3.new(0,0,0)
speedLabel.Font             = Enum.Font.GothamBold
speedLabel.TextSize         = 20

local upBtn = Instance.new("TextButton", frame)
upBtn.Size             = UDim2.new(0,36,0,36)
upBtn.Position         = UDim2.new(0.5,100,0,30)
upBtn.BackgroundColor3 = Color3.fromRGB(150,100,200)
upBtn.Text             = "+"
upBtn.Font             = Enum.Font.GothamBold
upBtn.TextSize         = 24

-- Vertical motion buttons
local vertUp = Instance.new("TextButton", frame)
vertUp.Size             = UDim2.new(0,48,0,36)
vertUp.Position         = UDim2.new(0,10,0,72)
vertUp.BackgroundColor3 = Color3.fromRGB(100,255,100)
vertUp.Text             = "UP"
vertUp.Font             = Enum.Font.GothamBold
vertUp.TextSize         = 16

local vertDown = Instance.new("TextButton", frame)
vertDown.Size             = UDim2.new(0,48,0,36)
vertDown.Position         = UDim2.new(0,60,0,72)
vertDown.BackgroundColor3 = Color3.fromRGB(200,255,150)
vertDown.Text             = "DOWN"
vertDown.Font             = Enum.Font.GothamBold
vertDown.TextSize         = 16

-- Thumbstick
local stickFrame = Instance.new("Frame", gui)
stickFrame.Size               = UDim2.new(0,120,0,120)
stickFrame.Position           = UDim2.new(0,10,1,-150)
stickFrame.BackgroundTransparency = 1
stickFrame.Active             = true

local base = Instance.new("ImageLabel", stickFrame)
base.Size               = UDim2.new(1,0,1,0)
base.Image              = "rbxassetid://3926305904"
base.BackgroundTransparency = 1
base.ImageColor3        = Color3.fromRGB(50,50,50)

local knob = Instance.new("ImageLabel", stickFrame)
knob.Size               = UDim2.new(0,60,0,60)
knob.Position           = UDim2.new(0.5,-30,0.5,-30)
knob.Image              = "rbxassetid://3926307971"
knob.BackgroundTransparency = 1
knob.ImageColor3        = Color3.fromRGB(100,100,100)

-- Greeting label + Sound
local greetLbl = Instance.new("TextLabel", gui)
greetLbl.Size              = UDim2.new(0,200,0,40)
greetLbl.Position          = UDim2.new(0.5,-100,0.3,0)
greetLbl.BackgroundColor3  = Color3.fromRGB(40,40,40)
greetLbl.TextColor3        = Color3.new(1,1,1)
greetLbl.Font              = Enum.Font.GothamBold
greetLbl.TextSize          = 18
greetLbl.Text              = "ahmed’s fly gui"
greetLbl.TextScaled        = true

local sound = Instance.new("Sound", gui)
sound.SoundId = "rbxassetid://142376088"  -- loading chime
sound.Volume  = 1
sound:Play()

-- Remove greeting after 3 seconds
delay(3, function()
    greetLbl:Destroy()
    sound:Stop()
end)

-- State
local flying    = false
local flySpeed  = speedMap[speedLevel]
local direction = Vector3.zero
local dragging  = false

-- BodyVelocity
local bv = Instance.new("BodyVelocity", root)
bv.Name     = "FlyVelocity"
bv.MaxForce = Vector3.new()
bv.Velocity = Vector3.zero
bv.P        = 12500

-- Helpers to recalc thumbstick center
local function getCenter()
    local pos = stickFrame.AbsolutePosition
    local sz  = stickFrame.AbsoluteSize
    return Vector2.new(pos.X + sz.X/2, pos.Y + sz.Y/2)
end

-- Thumbstick input
stickFrame.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch then dragging=true end
end)
stickFrame.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch then
        dragging = false
        direction = Vector3.zero
        knob.Position = UDim2.new(0.5,-30,0.5,-30)
    end
end)
stickFrame.InputChanged:Connect(function(i)
    if dragging and i.UserInputType==Enum.UserInputType.Touch then
        local cen   = getCenter()
        local delta = i.Position - cen
        local maxR  = stickFrame.AbsoluteSize.X/2
        local dist  = math.min(delta.Magnitude, maxR)
        local n     = delta.Unit * (dist/maxR)
        knob.Position = UDim2.new(0.5, n.X*maxR-30, 0.5, n.Y*maxR-30)
        -- map thumb Y→ forward
        direction = Vector3.new(n.X, 0, -n.Y)
    end
end)

-- Fly toggle
flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyBtn.BackgroundColor3 = Color3.fromRGB(80,255,80)
        flyBtn.Text             = "Fly: ON"
        bv.MaxForce             = Vector3.new(1e5,1e5,1e5)
    else
        flyBtn.BackgroundColor3 = Color3.fromRGB(255,80,80)
        flyBtn.Text             = "Fly: OFF"
        bv.MaxForce             = Vector3.new()
        bv.Velocity             = Vector3.zero
        direction               = Vector3.zero
    end
end)

-- Speed level controls
upBtn.MouseButton1Click:Connect(function()
    speedLevel = math.clamp(speedLevel+1, 1, #speedMap)
    flySpeed   = speedMap[speedLevel]
    speedLabel.Text = tostring(speedLevel)
end)
downBtn.MouseButton1Click:Connect(function()
    speedLevel = math.clamp(speedLevel-1, 1, #speedMap)
    flySpeed   = speedMap[speedLevel]
    speedLabel.Text = tostring(speedLevel)
end)

-- Vertical movement
vertUp.MouseButton1Click:Connect(function()
    if flying then
        root.CFrame = root.CFrame + Vector3.new(0, flySpeed * RunService.RenderStepped:Wait(), 0)
    end
end)
vertDown.MouseButton1Click:Connect(function()
    if flying then
        root.CFrame = root.CFrame - Vector3.new(0, flySpeed * RunService.RenderStepped:Wait(), 0)
    end
end)

-- Close & Reopen
close.MouseButton1Click:Connect(function()
    frame.Visible      = false
    stickFrame.Visible = false
    reopen.Visible     = true
end)
reopen.MouseButton1Click:Connect(function()
    frame.Visible      = true
    stickFrame.Visible = true
    reopen.Visible     = false
end)

-- Main flight loop
RunService.RenderStepped:Connect(function(dt)
    if flying then
        -- horizontal
        local cam   = workspace.CurrentCamera
        local right = cam.CFrame.RightVector * direction.X
        local fwd   = cam.CFrame.LookVector * direction.Z
        bv.Velocity = (right + fwd).Unit * flySpeed
    end
end)
