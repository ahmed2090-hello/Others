-- Services
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local player     = Players.LocalPlayer
local char       = player.Character or player.CharacterAdded:Wait()
local root       = char:WaitForChild("HumanoidRootPart")

-- Setup GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AhmedFlyScript"
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
frame.Active = true
frame.Draggable = true
frame.Name = "FlyGUI"

-- Helper to make buttons
local function createButton(parent, text, pos, size, color)
	local button = Instance.new("TextButton", parent)
	button.Text = text
	button.Size = size
	button.Position = pos
	button.BackgroundColor3 = color
	button.TextColor3 = Color3.new(0,0,0)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	return button
end

-- Close Button (X)
local close = createButton(frame, "X", UDim2.new(0,0,0,0), UDim2.new(0,40,0,30), Color3.fromRGB(255, 0, 0))
close.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

-- Speed Minus
local speedDown = createButton(frame, "-", UDim2.new(0,40,0,0), UDim2.new(0,40,0,30), Color3.fromRGB(150, 100, 200))

-- UP
local up = createButton(frame, "UP", UDim2.new(0,0,0,30), UDim2.new(0,40,0,30), Color3.fromRGB(100, 255, 100))

-- Speed Plus
local speedUp = createButton(frame, "+", UDim2.new(0,40,0,30), UDim2.new(0,40,0,30), Color3.fromRGB(150, 100, 200))

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(0, 130, 0, 30)
title.Position = UDim2.new(0, 80, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(255, 100, 255)
title.Text = "ahmed’s fly script"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

-- DOWN
local down = createButton(frame, "DOWN", UDim2.new(0,0,0,60), UDim2.new(0,40,0,30), Color3.fromRGB(200, 255, 150))

-- Speed Label
local speedLabel = createButton(frame, "4", UDim2.new(0,80,0,60), UDim2.new(0,40,0,30), Color3.fromRGB(255, 165, 0))
speedLabel.TextScaled = true
speedLabel.TextWrapped = true

-- Fly Button
local flyBtn = createButton(frame, "fly", UDim2.new(0,120,0,60), UDim2.new(0,100,0,30), Color3.fromRGB(255, 255, 100))

-- Fly logic
local flySpeed = 4
local flying = false
local bv = Instance.new("BodyVelocity", root)
bv.Name = "AhmedFlyVelocity"
bv.MaxForce = Vector3.zero
bv.Velocity = Vector3.zero
bv.P = 12500

-- Fly toggle
flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)
		flyBtn.BackgroundColor3 = Color3.fromRGB(150, 255, 150)
	else
		bv.MaxForce = Vector3.zero
		bv.Velocity = Vector3.zero
		flyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 100)
	end
end)

-- Speed control
speedUp.MouseButton1Click:Connect(function()
	flySpeed += 1
	speedLabel.Text = tostring(flySpeed)
end)
speedDown.MouseButton1Click:Connect(function()
	flySpeed = math.max(1, flySpeed - 1)
	speedLabel.Text = tostring(flySpeed)
end)

-- Up/down movement
up.MouseButton1Click:Connect(function()
	if flying then
		root.CFrame = root.CFrame + Vector3.new(0, flySpeed, 0)
	end
end)
down.MouseButton1Click:Connect(function()
	if flying then
		root.CFrame = root.CFrame - Vector3.new(0, flySpeed, 0)
	end
end)

-- Forward flight
RunService.RenderStepped:Connect(function()
	if flying then
		local cam = workspace.CurrentCamera
		local dir = cam.CFrame.LookVector
		bv.Velocity = dir * flySpeed * 5
	end
end)
