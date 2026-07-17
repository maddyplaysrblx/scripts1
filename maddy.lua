-- Dead Rails Simple - Xeno Compatible
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Simple UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeadRailsSimple"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 300)
Frame.Position = UDim2.new(0, 10, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "Dead Rails"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

-- Functions
local function CollectBonds()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("bond") then
            if v:FindFirstChildWhichIsA("TouchInterest") then
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 1)
            end
        end
    end
end

local function BringItems()
    local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local name = v.Name:lower()
            if name:find("bandage") or name:find("gun") or name:find("weapon") or name:find("ammo") then
                v.CFrame = HRP.CFrame + Vector3.new(0, 3, 0)
                task.wait(0.1)
            end
        end
    end
end

-- Buttons
local function CreateButton(text, yPos, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 35)
    Button.Position = UDim2.new(0.05, 0, 0, yPos)
    Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.SourceSans
    Button.Parent = Frame
    
    Button.MouseButton1Click:Connect(callback)
    return Button
end

CreateButton("Collect Bonds", 40, CollectBonds)
CreateButton("Bring Items", 80, BringItems)
CreateButton("Speed 100", 120, function()
    LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)
CreateButton("Speed 16 (Reset)", 160, function()
    LocalPlayer.Character.Humanoid.WalkSpeed = 16
end)
CreateButton("Close GUI", 200, function()
    ScreenGui:Destroy()
end)

print("Dead Rails script loaded!")
