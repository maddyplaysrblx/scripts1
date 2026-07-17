-- Dead Rails Ultimate - Loadstring Version
-- Save this as ringta.lua (or any name) in your GitHub repo

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Load Orion UI Library
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- Create Window
local Window = OrionLib:MakeWindow({
    Name = "Dead Rails | Ultimate",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "DeadRails",
    IntroEnabled = true,
    IntroText = "Dead Rails Ultimate",
    IntroIcon = "rbxassetid://4483345998"
})

-- Settings
getgenv().DeadRailsSettings = {
    AutoBonds = false,
    AutoItems = false,
    ItemESP = false,
    WalkSpeed = 16,
    JumpPower = 50,
    NoClip = false,
    FullBright = false,
    GodMode = false,
    AutoShoot = false,
    InfiniteAmmo = false,
    InstantRevive = false
}

-- Notification Function
local function Notify(title, text)
    OrionLib:MakeNotification({
        Name = title,
        Content = text,
        Image = "rbxassetid://4483345998",
        Time = 3
    })
end

-- Auto Bonds
local function AutoCollectBonds()
    while getgenv().DeadRailsSettings.AutoBonds and task.wait(0.1) do
        pcall(function()
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("MeshPart") then
                    local name = v.Name:lower()
                    if name:find("bond") or name:find("money") or name:find("cash") or name:find("gold") or name:find("coin") then
                        if v:FindFirstChildWhichIsA("TouchInterest") then
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0)
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 1)
                        end
                    end
                end
            end
        end)
    end
end

-- Auto Bring Items
local function BringItems()
    while getgenv().DeadRailsSettings.AutoItems and task.wait(0.3) do
        pcall(function()
            local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not HRP then return end
            
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("MeshPart") or v:IsA("Tool") then
                    local name = v.Name:lower()
                    
                    -- Collectible items
                    if name:find("bandage") or name:find("medkit") or name:find("heal") or
                       name:find("weapon") or name:find("gun") or name:find("rifle") or
                       name:find("pistol") or name:find("shotgun") or name:find("smg") or
                       name:find("ammo") or name:find("bullet") or name:find("magazine") or
                       name:find("food") or name:find("water") or name:find("supply") or
                       name:find("crate") or name:find("chest") or name:find("loot") or
                       name:find("key") or name:find("map") or name:find("note") then
                        
                        if v:FindFirstChildWhichIsA("TouchInterest") or v:IsA("Tool") then
                            if v:IsA("BasePart") then
                                v.CFrame = HRP.CFrame + Vector3.new(math.random(-2,2), 0, math.random(-2,2))
                            elseif v:IsA("Tool") and v.Parent == Workspace then
                                LocalPlayer.Character.Humanoid:EquipTool(v)
                            end
                            
                            task.wait(0.05)
                            if v:FindFirstChildWhichIsA("TouchInterest") then
                                firetouchinterest(HRP, v, 0)
                                firetouchinterest(HRP, v, 1)
                            end
                        end
                    end
                end
            end
        end)
    end
end

-- ESP System
local ESPObjects = {}
local function CreateESP(object, text, color)
    if ESPObjects[object] then return end
    
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "DeadRailsESP"
    Billboard.AlwaysOnTop = true
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.StudsOffset = Vector3.new(0, 3, 0)
    
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = text
    TextLabel.TextColor3 = color or Color3.fromRGB(255, 255, 0)
    TextLabel.TextStrokeTransparency = 0
    TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.TextScaled = true
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.Parent = Billboard
    
    Billboard.Parent = object
    ESPObjects[object] = Billboard
    
    object.Destroying:Connect(function()
        if ESPObjects[object] then
            ESPObjects[object]:Destroy()
            ESPObjects[object] = nil
        end
    end)
end

local function ItemESP()
    while getgenv().DeadRailsSettings.ItemESP and task.wait(1) do
        pcall(function()
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("MeshPart") or v:IsA("Model") then
                    local name = v.Name:lower()
                    
                    if name:find("bond") or name:find("money") or name:find("cash") or name:find("coin") then
                        CreateESP(v, "💰 BOND", Color3.fromRGB(0, 255, 0))
                    elseif name:find("weapon") or name:find("gun") or name:find("rifle") or name:find("pistol") or name:find("shotgun") then
                        CreateESP(v, "🔫 WEAPON", Color3.fromRGB(255, 0, 0))
                    elseif name:find("bandage") or name:find("medkit") or name:find("heal") then
                        CreateESP(v, "❤️ MEDICAL", Color3.fromRGB(255, 255, 0))
                    elseif name:find("ammo") or name:find("bullet") or name:find("magazine") then
                        CreateESP(v, "📦 AMMO", Color3.fromRGB(255, 165, 0))
                    elseif name:find("food") or name:find("water") or name:find("supply") then
                        CreateESP(v, "🍞 SUPPLY", Color3.fromRGB(0, 150, 255))
                    elseif name:find("crate") or name:find("chest") or name:find("loot") or name:find("box") then
                        CreateESP(v, "📦 LOOT", Color3.fromRGB(255, 0, 255))
                    elseif name:find("key") then
                        CreateESP(v, "🔑 KEY", Color3.fromRGB(255, 215, 0))
                    end
                end
            end
        end)
    end
end

local function ClearESP()
    for object, billboard in pairs(ESPObjects) do
        if billboard then billboard:Destroy() end
    end
    table.clear(ESPObjects)
end

-- Auto Shoot
local function AutoShoot()
    while getgenv().DeadRailsSettings.AutoShoot and task.wait(0.1) do
        pcall(function()
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("Fire") then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                        local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if distance < 100 and player.Character.Humanoid.Health > 0 then
                            local remote = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("Fire")
                            if remote then
                                remote:FireServer(player.Character.HumanoidRootPart.Position)
                            end
                        end
                    end
                end
            end
        end)
    end
end

-- Infinite Ammo
local function InfiniteAmmoLoop()
    while getgenv().DeadRailsSettings.InfiniteAmmo and task.wait(0.5) do
        pcall(function()
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Clip")
                if ammo and ammo:IsA("IntValue") then
                    ammo.Value = 999
                end
            end
            
            -- Check backpack too
            for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Clip")
                if ammo and ammo:IsA("IntValue") then
                    ammo.Value = 999
                end
            end
        end)
    end
end

-- Instant Revive
local function InstantRevive()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        if humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then
            -- Respawn instantly
            local spawnLocations = Workspace:FindFirstChild("SpawnLocations") or Workspace:FindFirstChild("Spawns")
            if spawnLocations then
                local spawn = spawnLocations:GetChildren()[1]
                if spawn then
                    LocalPlayer.Character:SetPrimaryPartCFrame(spawn.CFrame)
                end
            end
        end
    end
end

-- UI Tabs
local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998"})
local PlayerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998"})
local CombatTab = Window:MakeTab({Name = "Combat", Icon = "rbxassetid://4483345998"})
local VisualTab = Window:MakeTab({Name = "Visuals", Icon = "rbxassetid://4483345998"})
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483345998"})

-- Main Tab
MainTab:AddToggle({
    Name = "Auto Collect Bonds",
    Default = false,
    Callback = function(Value)
        getgenv().DeadRailsSettings.AutoBonds = Value
        if Value then task.spawn(AutoCollectBonds) end
        Notify("Auto Bonds", Value and "Enabled" or "Disabled")
    end
})

MainTab:AddToggle({
    Name = "Auto Bring Items",
    Default = false,
    Callback = function(Value)
        getgenv().DeadRailsSettings.AutoItems = Value
        if Value then task.spawn(BringItems) end
        Notify("Auto Items", Value and "Enabled" or "Disabled")
    end
})

MainTab:AddButton({
    Name = "Collect All Bonds (Instant)",
    Callback = function()
        local count = 0
        pcall(function()
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    local name = v.Name:lower()
                    if name:find("bond") or name:find("money") or name:find("cash") then
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0)
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 1)
                        count = count + 1
                    end
                end
            end
        end)
        Notify("Instant Collect", "Collected " .. count .. " bonds!")
    end
})

MainTab:AddButton({
    Name = "Bring All Items (Instant)",
    Callback = function()
        local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not HRP then return end
        
        local count = 0
        pcall(function()
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    local name = v.Name:lower()
                    if name:find("bandage") or name:find("weapon") or name:find("gun") or name:find("ammo") then
                        v.CFrame = HRP.CFrame + Vector3.new(math.random(-3,3), 0, math.random(-3,3))
                        count = count + 1
                    end
                end
            end
        end)
        Notify("Instant Bring", "Brought " .. count .. " items!")
    end
})

-- Player Tab
PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    Callback = function(Value)
        getgenv().DeadRailsSettings.WalkSpeed = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end    
})

PlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    Callback = function(Value)
        getgenv().DeadRailsSettings.JumpPower = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    end    
})

PlayerTab:AddToggle({
    Name = "No Clip",
    Default = false,
    Callback = function(Value)
        getgenv().DeadRailsSettings.NoClip = Value
        Notify("No Clip", Value and "Enabled" or "Disabled")
    end
})

PlayerTab:AddToggle({
    Name = "God Mode",
    Default = false,
    Callback = function(Value)
        getgenv().DeadRailsSettings.GodMode = Value
        pcall(function()
            LocalPlayer.Character.Humanoid.MaxHealth = Value and math.huge or 100
            LocalPlayer.Character.Humanoid.Health = Value and math.huge or 100
        end)
        Notify("God Mode", Value and "Enabled" or "Disabled")
    end
})

-- Combat Tab
CombatTab:AddToggle({
    Name = "Auto Shoot (Silent Aim)",
    Default = false,
    Callback = function(Value)
        getgenv().DeadRailsSettings.AutoShoot = Value
        if Value then task.spawn(AutoShoot) end
        Notify("Auto Shoot", Value and "Enabled" or "Disabled")
    end
})

CombatTab:AddToggle({
    Name = "Infinite Ammo",
    Default = false,
    Callback = function(Value)
        getgenv().DeadRailsSettings.InfiniteAmmo = Value
        if Value then task.spawn(InfiniteAmmoLoop) end
        Notify("Infinite Ammo", Value and "Enabled" or "Disabled")
    end
})

CombatTab:AddButton({
    Name = "Instant Revive",
    Callback = function()
        InstantRevive()
        Notify("Revive", "Revived!")
    end
})

-- Visual Tab
VisualTab:AddToggle({
    Name = "Item ESP",
    Default = false,
    Callback = function(Value)
        getgenv().DeadRailsSettings.ItemESP = Value
        if Value then
            task.spawn(ItemESP)
            Notify("ESP", "Item ESP enabled!")
        else
            ClearESP()
            Notify("ESP", "Item ESP disabled!")
        end
    end
})

VisualTab:AddToggle({
    Name = "Full Bright",
    Default = false,
    Callback = function(Value)
        getgenv().DeadRailsSettings.FullBright = Value
        if Value then
            game.Lighting.Brightness = 10
            game.Lighting.GlobalShadows = false
            game.Lighting.FogEnd = 999999
            game.Lighting.ClockTime = 12
        else
            game.Lighting.Brightness = 1
            game.Lighting.GlobalShadows = true
            game.Lighting.FogEnd = 1000
        end
        Notify("Full Bright", Value and "Enabled" or "Disabled")
    end
})

VisualTab:AddButton({
    Name = "Remove Fog",
    Callback = function()
        game.Lighting.FogEnd = 999999
        game.Lighting.FogStart = 99999
        Notify("Visuals", "Fog removed!")
    end
})

-- Misc Tab
MiscTab:AddButton({
    Name = "Anti-AFK",
    Callback = function()
        local VirtualUser = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        Notify("Anti-AFK", "Enabled!")
    end
})

MiscTab:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
})

MiscTab:AddButton({
    Name = "Server Hop",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local ApiURL = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        
        local success, Data = pcall(function() return game:HttpGet(ApiURL) end)
        if success then
            local Servers = HttpService:JSONDecode(Data)
            for _, v in pairs(Servers.data) do
                if v.playing < v.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                    break
                end
            end
        end
    end
})

MiscTab:AddButton({
    Name = "Destroy GUI",
    Callback = function()
        OrionLib:Destroy()
    end
})

-- Loops
RunService.Stepped:Connect(function()
    if getgenv().DeadRailsSettings.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- Character Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.WalkSpeed = getgenv().DeadRailsSettings.WalkSpeed
    humanoid.JumpPower = getgenv().DeadRailsSettings.JumpPower
    
    if getgenv().DeadRailsSettings.GodMode then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
end)

-- Init
OrionLib:Init()
Notify("Dead Rails Ultimate", "Script loaded successfully!")
Notify("Version", "v2.0 | Loadstring Ready")
