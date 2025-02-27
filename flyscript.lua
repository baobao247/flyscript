local player = game.Players.LocalPlayer
local flying = false
local speed = 50

local function fly(character)
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    bodyVelocity.Parent = rootPart

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.D = 500
    bodyGyro.P = 3000
    bodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
    bodyGyro.Parent = rootPart

    while flying and character.Parent do
        local camera = game.Workspace.CurrentCamera
        local direction = camera.CFrame.LookVector * speed
        if humanoid.MoveDirection.Magnitude > 0 then
            direction = humanoid.MoveDirection * speed
        end
        bodyVelocity.Velocity = Vector3.new(direction.X, direction.Y, direction.Z)
        bodyGyro.CFrame = camera.CFrame
        wait()
    end

    bodyVelocity:Destroy()
    bodyGyro:Destroy()
end

local function createGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BGrok3"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 150)
    Frame.Position = UDim2.new(0.5, -100, 0.5, -75)
    Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    Frame.Parent = ScreenGui
    Frame.Active = true
    Frame.Draggable = true

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 180, 0, 20)
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.Text = "BGrok3"
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18
    Title.Parent = Frame

    local FlyButton = Instance.new("TextButton")
    FlyButton.Size = UDim2.new(0, 180, 0, 40)
    FlyButton.Position = UDim2.new(0, 10, 0, 35)
    FlyButton.Text = "Toggle Fly: OFF"
    FlyButton.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    FlyButton.TextColor3 = Color3.new(1, 1, 1)
    FlyButton.Parent = Frame

    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Size = UDim2.new(0, 180, 0, 20)
    SpeedLabel.Position = UDim2.new(0, 10, 0, 85)
    SpeedLabel.Text = "Speed: " .. speed
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
    SpeedLabel.Parent = Frame

    local SpeedUpButton = Instance.new("TextButton")
    SpeedUpButton.Size = UDim2.new(0, 80, 0, 30)
    SpeedUpButton.Position = UDim2.new(0, 10, 0, 115)
    SpeedUpButton.Text = "Speed +"
    SpeedUpButton.BackgroundColor3 = Color3.new(0, 0.6, 0)
    SpeedUpButton.TextColor3 = Color3.new(1, 1, 1)
    SpeedUpButton.Parent = Frame

    local SpeedDownButton = Instance.new("TextButton")
    SpeedDownButton.Size = UDim2.new(0, 80, 0, 30)
    SpeedDownButton.Position = UDim2.new(0, 100, 0, 115)
    SpeedDownButton.Text = "Speed -"
    SpeedDownButton.BackgroundColor3 = Color3.new(0.6, 0, 0)
    SpeedDownButton.TextColor3 = Color3.new(1, 1, 1)
    SpeedDownButton.Parent = Frame

    FlyButton.MouseButton1Click:Connect(function()
        flying = not flying
        FlyButton.Text = "Toggle Fly: " .. (flying and "ON" or "OFF")
        if flying then
            spawn(function() fly(player.Character or player.CharacterAdded:Wait()) end)
        end
    end)

    SpeedUpButton.MouseButton1Click:Connect(function()
        speed = speed + 10
        SpeedLabel.Text = "Speed: " .. speed
    end)

    SpeedDownButton.MouseButton1Click:Connect(function()
        if speed > 10 then
            speed = speed - 10
            SpeedLabel.Text = "Speed: " .. speed
        end
    end)
end

local function onCharacterAdded(character)
    if flying then
        spawn(function() fly(character) end)
    end
end

createGUI()
player.CharacterAdded:Connect(onCharacterAdded)
print("BGrok3 flight script loaded!")
