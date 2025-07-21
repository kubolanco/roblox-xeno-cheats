-// Advanced Roblox Local Script with Even More Features

local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
local flying, godmode, invis, noclip, infJump, spinbot, btools, superStrength = false, false, false, false, false, false, false, false

-- Utility for character reference
local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHum()
    return getChar():FindFirstChildOfClass("Humanoid")
end

-- Fly function using BodyVelocity
local bv = nil
function startFlying()
    if not getChar() or not getHum() then return end
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = getChar().PrimaryPart or getChar():FindFirstChild("HumanoidRootPart")
        flying = true
    end
end

function stopFlying()
    flying = false
    if bv then bv:Destroy() bv = nil end
end

-- Speed boost
function speedBoost()
    local hum = getHum()
    if hum then hum.WalkSpeed = 100 end
end

-- Invisible
function goInvisible()
    local char = getChar()
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            v.Transparency = 1
        elseif v:IsA("Decal") then
            v.Transparency = 1
        end
    end
    invis = true
end

function goVisible()
    local char = getChar()
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            v.Transparency = 0
        elseif v:IsA("Decal") then
            v.Transparency = 0
        end
    end
    invis = false
end

-- Godmode
function enableGodmode()
    godmode = true
end

function disableGodmode()
    godmode = false
end

-- Teleport to mouse
function teleportToMouse()
    local char = getChar()
    if mouse and mouse.Hit then
        char:MoveTo(mouse.Hit.p)
    end
end

-- Restore normal state
function restoreNormal()
    local hum = getHum()
    if hum then
        hum.WalkSpeed = 16
        hum.JumpPower = 50
    end
    goVisible()
    disableGodmode()
    infJump = false
    stopFlying()
    noclip = false
    spinbot = false
    if btools then removeBtools() end
    btools = false
    superStrength = false
end

-- Teleport to first other player
function teleportToFirstPlayer()
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            getChar():MoveTo(p.Character.HumanoidRootPart.Position)
            break
        end
    end
end

-- Random teleport to player
function randomTeleport()
    local players = {}
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(players, p)
        end
    end
    if #players > 0 then
        local choice = players[math.random(1, #players)]
        getChar():MoveTo(choice.Character.HumanoidRootPart.Position)
    end
end

-- Sit / Unsit toggle
function toggleSit()
    local hum = getHum()
    if hum then
        hum.Sit = not hum.Sit
    end
end

-- Btools
function giveBtools()
    local backpack = player:FindFirstChildOfClass("Backpack")
    if not backpack then return end
    local toolNames = {"Clone", "Hammer", "Grab"}
    for _, toolName in ipairs(toolNames) do
        local tool = Instance.new("HopperBin")
        tool.BinType = toolName == "Clone" and Enum.BinType.Clone or toolName == "Hammer" and Enum.BinType.Hammer or Enum.BinType.Grab
        tool.Name = toolName .. "Tool"
        tool.Parent = backpack
    end
    btools = true
end
function removeBtools()
    local backpack = player:FindFirstChildOfClass("Backpack")
    if not backpack then return end
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("HopperBin") then
            tool:Destroy()
        end
    end
end

-- Super Strength: destroy touched parts
function enableSuperStrength()
    local char = getChar()
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Touched:Connect(function(hit)
                if superStrength and hit and hit.Parent and not hit:IsDescendantOf(char) then
                    hit:Destroy()
                end
            end)
        end
    end
    superStrength = true
end

-- Custom GUI (simple example)
function createGui()
    local screenGui = Instance.new("ScreenGui", player.PlayerGui)
    screenGui.Name = "FeatureGui"
    local infoLabel = Instance.new("TextLabel", screenGui)
    infoLabel.Size = UDim2.new(0, 350, 0, 180)
    infoLabel.Position = UDim2.new(0, 10, 0, 10)
    infoLabel.BackgroundTransparency = 0.5
    infoLabel.TextScaled = true
    infoLabel.TextColor3 = Color3.fromRGB(0,255,0)
    infoLabel.Text = [[
N: Fly
K: JumpPower 100
L: Speed Boost
J: Invisible
H: Godmode
T: Teleport to mouse
M: Restore normal
B: Noclip
V: Infinite Jump
Z: Teleport to first player
X: Random teleport
C: Sit/Unsit
Y: Spinbot
P: Btools
S: Super Strength
G: Show/Hide GUI
]]
    infoLabel.Visible = true
    return infoLabel
end

local guiLabel = createGui()

-- Toggle GUI
function toggleGui()
    if guiLabel then
        guiLabel.Visible = not guiLabel.Visible
    end
end

-- Keybinds
mouse.KeyDown:Connect(function(key)
    key = key:lower()
    if key == "n" then
        if flying then stopFlying() else startFlying() end
    elseif key == "k" then
        local hum = getHum()
        if hum then hum.JumpPower = 100 end
    elseif key == "l" then
        speedBoost()
    elseif key == "j" then
        if not invis then goInvisible() else goVisible() end
    elseif key == "h" then
        if not godmode then enableGodmode() else disableGodmode() end
    elseif key == "t" then
        teleportToMouse()
    elseif key == "m" then
        restoreNormal()
    elseif key == "b" then
        noclip = not noclip
    elseif key == "v" then
        infJump = not infJump
    elseif key == "z" then
        teleportToFirstPlayer()
    elseif key == "x" then
        randomTeleport()
    elseif key == "c" then
        toggleSit()
    elseif key == "y" then
        spinbot = not spinbot
    elseif key == "p" then
        if not btools then giveBtools() else removeBtools() end
    elseif key == "s" then
        if not superStrength then enableSuperStrength() else superStrength = false end
    elseif key == "g" then
        toggleGui()
    end
end)

-- Flying logic
game:GetService("RunService").Heartbeat:Connect(function()
    if flying and getChar() and getChar().PrimaryPart then
        local cam = workspace.CurrentCamera
        local moveVec = Vector3.new()
        if mouse:IsKeyDown("w") then moveVec += cam.CFrame.LookVector end
        if mouse:IsKeyDown("s") then moveVec -= cam.CFrame.LookVector end
        if mouse:IsKeyDown("a") then moveVec -= cam.CFrame.RightVector end
        if mouse:IsKeyDown("d") then moveVec += cam.CFrame.RightVector end
        bv.Velocity = moveVec.Magnitude > 0 and moveVec.Unit * 50 or Vector3.new(0,0,0)
    end
end)

-- Godmode logic
game:GetService("RunService").Heartbeat:Connect(function()
    if godmode then
        local hum = getHum()
        if hum and hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
    end
end)

-- Noclip logic
game:GetService("RunService").Stepped:Connect(function()
    if noclip then
        for _, v in pairs(getChar():GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- Infinite jump logic
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump then
        local root = getChar():FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(0, 50, 0)
        end
    end
end)

-- Spinbot logic
game:GetService("RunService").Heartbeat:Connect(function()
    if spinbot then
        local root = getChar():FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(15), 0)
        end
    end
end)

-- Anti-Kick
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if tostring(self) == "Players" and method == "Kick" then
        return nil
    end
    return oldNamecall(self, unpack(args))
end
setreadonly(mt, true)

-- Chat Spy
for _, playerObj in pairs(game:GetService("Players"):GetPlayers()) do
    playerObj.Chatted:Connect(function(msg)
        print("[ChatSpy] " .. playerObj.Name .. ": " .. msg)
    end)
end
game:GetService("Players").PlayerAdded:Connect(function(plr)
    plr.Chatted:Connect(function(msg)
        print("[ChatSpy] " .. plr.Name .. ": " .. msg)
    end)
end)

-- Anti-Reset
game:GetService("RunService").Stepped:Connect(function()
    local hum = getHum()
    if hum and hum.Health <= 0 then
        hum.Health = hum.MaxHealth
    end
end)

-- ESP
local function createESP(target)
    local box = Instance.new("BoxHandleAdornment", target)
    box.Adornee = target
    box.Size = target.Size + Vector3.new(0.1, 0.1, 0.1)
    box.Color3 = Color3.new(1, 0, 0)
    box.Transparency = 0.5
    box.AlwaysOnTop = true
end

for _, p in pairs(game:GetService("Players"):GetPlayers()) do
    if p ~= player and p.Character then
        for _, part in pairs(p.Character:GetChildren()) do
            if part:IsA("BasePart") then
                createESP(part)
            end
        end
    end
end

game:GetService("Players").PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        wait(1)
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                createESP(part)
            end
        end
    end)
end)
