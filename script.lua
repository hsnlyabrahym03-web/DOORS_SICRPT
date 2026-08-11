local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Doors Ultimate Script",
   LoadingTitle = "Loading Ultimate Script...",
   LoadingSubtitle = "Please wait...",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local MainTab = Window:CreateTab("Player Controls", 4483362458)
local DoorsTab = Window:CreateTab("Doors Visuals", 4483362458)
local MonstersTab = Window:CreateTab("Monsters & Safe", 4483362458)

local AutoClickEnabled = true
local InstantInteractEnabled = true
local KeyESP = false
local DoorESP = false
local ItemESP = false
local MonsterESP = true
local MonsterNotifier = true
local AntiMonstersEnabled = true
local FullbrightEnabled = true

workspace.CurrentCamera.FieldOfView = 120

-- Fullbright (Night Vision)
task.spawn(function()
    while task.wait(0.2) do
        if FullbrightEnabled then
            pcall(function()
                local lighting = game:GetService("Lighting")
                lighting.Brightness = 2
                lighting.ClockTime = 14
                lighting.FogEnd = 100000
                lighting.GlobalShadows = false
                lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            end)
        end
    end
end)

-- Auto Clicker
task.spawn(function()
    while task.wait(0.05) do
        if AutoClickEnabled then
            pcall(function()
                local player = game.Players.LocalPlayer
                local character = player.Character
                if character and character:FindFirstChildOfClass("Tool") then
                    character:FindFirstChildOfClass("Tool"):Activate()
                end
            end)
        end
    end
end)

-- Instant Doors Open & Proximity Prompts
task.spawn(function()
    while task.wait(0.1) do
        if InstantInteractEnabled then
            pcall(function()
                for _, prompt in pairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        prompt.HoldDuration = 0
                    end
                end
            end)
        end
    end
end)

-- Anti-Screech, Anti-Spider (Timothy) & Anti-Halt Engine (Seek is KEPT to prevent glitches)
task.spawn(function()
    while task.wait(0.1) do
        if AntiMonstersEnabled then
            pcall(function()
                local player = game.Players.LocalPlayer
                local camera = workspace.CurrentCamera

                -- Delete Screech
                if camera:FindFirstChild("Screech") then
                    camera.Screech:Destroy()
                end
                if player.Character and player.Character:FindFirstChild("Screech") then
                    player.Character.Screech:Destroy()
                end

                -- Delete Spider (Timothy)
                if camera:FindFirstChild("Spider") then
                    camera.Spider:Destroy()
                end
                if camera:FindFirstChild("Timothy") then
                    camera.Timothy:Destroy()
                end

                -- Remove Halt Effects / Hallway
                local haltRoom = workspace:FindFirstChild("HaltRoom") or workspace:FindFirstChild("ShadeRoom")
                if haltRoom then
                    haltRoom:Destroy()
                end
            end)
        end
    end
end)

local function applyHighlight(obj, color, name)
    if obj and not obj:FindFirstChild(name) then
        local highlight = Instance.new("Highlight")
        highlight.Name = name
        highlight.Adornee = obj
        highlight.FillColor = color
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.3
        highlight.Parent = obj
    end
end

local function removeHighlight(obj, name)
    if obj and obj:FindFirstChild(name) then
        obj[name]:Destroy()
    end
end

-- Monster Detector & Alert System (Includes Seek Notification)
workspace.ChildAdded:Connect(function(child)
    if MonsterNotifier or MonsterESP then
        task.wait(0.1)
        local monsterNames = {"RushMoving", "AmbushMoving", "SeekMoving", "FigureRig", "Eyes"}
        for _, name in pairs(monsterNames) do
            if child.Name == name or string.find(child.Name, "Rush") or string.find(child.Name, "Ambush") or string.find(child.Name, "Seek") then
                if MonsterNotifier then
                    Rayfield:Notify({
                       Title = "⚠️ WARNING! ⚠️",
                       Content = "Monster Spawning: " .. child.Name .. " - RUN / HIDE!",
                       Duration = 5,
                       Image = 4483362458,
                    })
                end
                if MonsterESP then
                    applyHighlight(child, Color3.fromRGB(255, 0, 0), "MonsterESP")
                end
            end
        end
    end
end)

-- General ESP Scanner
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local workspaceRooms = workspace:FindFirstChild("CurrentRooms")
            if workspaceRooms then
                for _, room in pairs(workspaceRooms:GetChildren()) do
                    for _, v in pairs(room:GetDescendants()) do
                        if KeyESP and (v.Name == "KeyObby" or v.Name == "Key") then
                            applyHighlight(v, Color3.fromRGB(255, 255, 0), "KeyESP")
                        elseif not KeyESP and (v.Name == "KeyObby" or v.Name == "Key") then
                            removeHighlight(v, "KeyESP")
                        end

                        if DoorESP and (v.Name == "Door" and v:FindFirstChild("Door")) then
                            applyHighlight(v, Color3.fromRGB(0, 255, 0), "DoorESP")
                        elseif not DoorESP and (v.Name == "Door" and v:FindFirstChild("Door")) then
                            removeHighlight(v, "DoorESP")
                        end

                        if ItemESP and (v:IsA("Model") and (v.Name == "Lighter" or v.Name == "Flashlight" or v.Name == "Vitamins" or v.Name == "Lockpick")) then
                            applyHighlight(v, Color3.fromRGB(0, 255, 255), "ItemESP")
                        elseif not ItemESP and (v:IsA("Model") and (v.Name == "Lighter" or v.Name == "Flashlight" or v.Name == "Vitamins" or v.Name == "Lockpick")) then
                            removeHighlight(v, "ItemESP")
                        end
                    end
                end
            end
        end)
    end
end)

MainTab:CreateSlider({
   Name = "Speed Hack (WalkSpeed)",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value)
       pcall(function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value end)
   end,
})

MainTab:CreateSlider({
   Name = "Camera FOV",
   Range = {70, 120},
   Increment = 1,
   CurrentValue = 120,
   Callback = function(Value)
       pcall(function() workspace.CurrentCamera.FieldOfView = Value end)
   end,
})

DoorsTab:CreateToggle({
   Name = "Fullbright (No Darkness)",
   CurrentValue = true,
   Callback = function(Value) FullbrightEnabled = Value end,
})

MainTab:CreateToggle({
   Name = "Instant Interact & Open Doors",
   CurrentValue = true,
   Callback = function(Value) InstantInteractEnabled = Value end,
})

MainTab:CreateToggle({
   Name = "Auto Clicker",
   CurrentValue = true,
   Callback = function(Value) AutoClickEnabled = Value end,
})

DoorsTab:CreateToggle({
   Name = "Keys ESP (Yellow)",
   CurrentValue = false,
   Callback = function(Value) KeyESP = Value end,
})

DoorsTab:CreateToggle({
   Name = "Doors ESP (Green)",
   CurrentValue = false,
   Callback = function(Value) DoorESP = Value end,
})

DoorsTab:CreateToggle({
   Name = "Items ESP (Cyan)",
   CurrentValue = false,
   Callback = function(Value) ItemESP = Value end,
})

MonstersTab:CreateToggle({
   Name = "No Screech, Halt & Spider (Timothy)",
   CurrentValue = true,
   Callback = function(Value) AntiMonstersEnabled = Value end,
})

MonstersTab:CreateToggle({
   Name = "Monster Alert Warnings",
   CurrentValue = true,
   Callback = function(Value) MonsterNotifier = Value end,
})

MonstersTab:CreateToggle({
   Name = "Monster ESP (Red Highlight)",
   CurrentValue = true,
   Callback = function(Value) MonsterESP = Value end,
})

Rayfield:Notify({
   Title = "Success!",
   Content = "Script Loaded (Seek Stable Mode).",
   Duration = 3,
   Image = 4483362458,
})
o
