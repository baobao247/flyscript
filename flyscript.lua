local player = game.Players.LocalPlayer
local flying = false
local speed = 50 -- Tốc độ mặc định

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
        local direction = Vector3.new(0, 0, 0) -- Đứng yên mặc định
        if humanoid.MoveDirection.Magnitude > 0 then
            -- Di chuyển theo hướng camera khi có input
            direction = camera.CFrame:VectorToWorldSpace(humanoid.MoveDirection) * speed
        end
        bodyVelocity.Velocity = direction
        -- Nhân vật xoay theo hướng camera (trục X)
        bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + camera.CFrame.LookVector)
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
    Frame.Size = UDim2.new(0, 150, 0, 150)
    Frame.Position = UDim2.new(0, 10, 0, 10) -- Đặt ở góc trên bên trái
    Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    Frame.Parent = ScreenGui
    Frame.Active = true
    Frame.Draggable = true

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 130, 0, 20)
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.Text = "BGrok3"
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 16
    Title.Parent = Frame

    local FlyButton = Instance.new("TextButton")
    FlyButton.Size = UDim2.new(0, 130, 0, 30)
    FlyButton.Position = UDim2.new(0, 10, 0, 30)
    FlyButton.Text = "Toggle Fly: OFF"
    FlyButton.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    FlyButton.TextColor3 = Color3.new(1, 1, 1)
    FlyButton.TextSize = 14
    FlyButton.Parent = Frame

    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Size = UDim2.new(0, 130, 0, 20)
    SpeedLabel.Position = UDim2.new(0, 10, 0, 65)
    SpeedLabel.Text = "Speed: " .. speed
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
    SpeedLabel.TextSize = 12
    SpeedLabel.Parent = Frame

    local SpeedInput = Instance.new("TextBox")
    SpeedInput.Size = UDim2.new(0, 130, 0, 25)
    SpeedInput.Position = UDim2.new(0, 10, 0, 90)
    SpeedInput.Text = tostring(speed)
    SpeedInput.PlaceholderText = "Enter speed"
    SpeedInput.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    SpeedInput.TextColor3 = Color3.new(1, 1, 1)
    SpeedInput.TextSize = 12
    SpeedInput.Parent = Frame

    local SpeedUpButton = Instance.new("TextButton")
    SpeedUpButton.Size = UDim2.new(0, 60, 0, 25)
    SpeedUpButton.Position = UDim2.new(0, 10, 0, 120)
    SpeedUpButton.Text = "Speed +"
    SpeedUpButton.BackgroundColor3 = Color3.new(0, 0.6, 0)
    SpeedUpButton.TextColor3 = Color3.new(1, 1, 1)
    SpeedUpButton.TextSize = 12
    SpeedUpButton.Parent = Frame

    local SpeedDownButton = Instance.new("TextButton")
    SpeedDownButton.Size = UDim2.new(0, 60, 0, 25)
    SpeedDownButton.Position = UDim2.new(0, 80, 0, 120)
    SpeedDownButton.Text = "Speed -"
    SpeedDownButton.BackgroundColor3 = Color3.new(0.6, 0, 0)
    SpeedDownButton.TextColor3 = Color3.new(1, 1, 1)
    SpeedDownButton.TextSize = 12
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
        SpeedInput.Text = tostring(speed)
    end)

    SpeedDownButton.MouseButton1Click:Connect(function()
        if speed > 10 then
            speed = speed - 10
            SpeedLabel.Text = "Speed: " .. speed
            SpeedInput.Text = tostring(speed)
        end
    end)

    SpeedInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local input = tonumber(SpeedInput.Text)
            if input and input >= 0 then
                speed = input
                SpeedLabel.Text = "Speed: " .. speed
            else
                SpeedInput.Text = tostring(speed)
            end
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
print("BGrok3 flight script loaded with camera-aligned rotation!")
