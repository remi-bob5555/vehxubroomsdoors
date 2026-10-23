local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer

local RANDOM_CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

local function randName(len)
    len = len or math.random(8, 14)
    local s = ""
    for _ = 1, len do
        local i = math.random(1, #RANDOM_CHARS)
        s = s .. RANDOM_CHARS:sub(i, i)
    end
    return s
end

local NAMES = {
    gui      = randName(12),
    folder   = randName(10),
    frame    = randName(9),
    title    = randName(8),
    notify   = randName(11),
    sound    = randName(9),
    hlFolder = randName(12),
}

local THEME = {
    bg           = Color3.fromRGB(10, 15, 35),
    panel        = Color3.fromRGB(20, 30, 60),
    accent       = Color3.fromRGB(40, 100, 200),
    text         = Color3.fromRGB(200, 220, 255),
    textDim      = Color3.fromRGB(120, 145, 190),
    checkboxOn   = Color3.fromRGB(40, 100, 200),
    checkboxOff  = Color3.fromRGB(25, 35, 65),
    notifyBg     = Color3.fromRGB(15, 22, 45),
    notifyBorder = Color3.fromRGB(40, 100, 200),
}

local FONT = Enum.Font.Code
local NOTIFY_SOUND_ID = "rbxassetid://7383525713"
local DEBUG_MODE = true

local ENTITY_MAP = {
    ["Multimonster (A-60)"]        = { "monster", "a-60", "multimonster" },
    ["Multimonster Prime (A-60')"] = { "a-60'", "a-60 prime", "monster_prime", "monsterprime" },
    ["Pnevma (A-100)"]             = { "a-100", "pnevma" },
    ["Happy Scribbles (A-120)"]    = { "a-120", "happyscribble", "happy scribble", "scribbles" },
    ["Insidae (A-200)"]            = { "a-200", "insidae", "insidæ" },
    ["Insidae Prime (A-200')"]     = { "a-200'", "a-200 prime", "insidaeprime", "insidæ_prime" },
}

local uiFolder = Instance.new("Folder")
uiFolder.Name = NAMES.folder
uiFolder.Parent = LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = NAMES.gui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.DisplayOrder = 999999
screenGui.IgnoreGuiInset = true
screenGui.Parent = uiFolder

local mainFrame = Instance.new("Frame")
mainFrame.Name = NAMES.frame
mainFrame.Size = UDim2.new(0, 260, 0, 220)
mainFrame.Position = UDim2.new(0, 20, 0.5, -110)
mainFrame.BackgroundColor3 = THEME.bg
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ZIndex = 100
mainFrame.Parent = screenGui

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = THEME.accent
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = NAMES.title
title.Size = UDim2.new(1, 0, 0, 32)
title.BackgroundColor3 = THEME.panel
title.BorderSizePixel = 0
title.Text = "VexHub - R&D"
title.TextColor3 = THEME.text
title.TextSize = 16
title.Font = FONT
title.ZIndex = 101
title.Parent = mainFrame

local checkboxContainer = Instance.new("Frame")
checkboxContainer.Name = randName(8)
checkboxContainer.Size = UDim2.new(1, -20, 0, 80)
checkboxContainer.Position = UDim2.new(0, 10, 0, 42)
checkboxContainer.BackgroundTransparency = 1
checkboxContainer.ZIndex = 101
checkboxContainer.Parent = mainFrame

local function createCheckbox(parent, yPos, labelText)
    local row = Instance.new("Frame")
    row.Name = randName(8)
    row.Size = UDim2.new(1, 0, 0, 32)
    row.Position = UDim2.new(0, 0, 0, yPos)
    row.BackgroundTransparency = 1
    row.ZIndex = 101
    row.Parent = parent

    local box = Instance.new("Frame")
    box.Name = randName(6)
    box.Size = UDim2.new(0, 22, 0, 22)
    box.Position = UDim2.new(0, 0, 0.5, -11)
    box.BackgroundColor3 = THEME.checkboxOff
    box.BorderSizePixel = 0
    box.ZIndex = 102
    box.Parent = row

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = THEME.accent
    boxStroke.Thickness = 1
    boxStroke.Parent = box

    local check = Instance.new("TextLabel")
    check.Name = randName(5)
    check.Size = UDim2.new(1, 0, 1, 0)
    check.BackgroundTransparency = 1
    check.Text = "[x]"
    check.TextColor3 = THEME.text
    check.TextSize = 14
    check.Font = FONT
    check.TextTransparency = 1
    check.ZIndex = 103
    check.Parent = box

    local label = Instance.new("TextLabel")
    label.Name = randName(7)
    label.Size = UDim2.new(1, -30, 1, 0)
    label.Position = UDim2.new(0, 30, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = THEME.textDim
    label.TextSize = 14
    label.Font = FONT
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 102
    label.Parent = row

    local button = Instance.new("TextButton")
    button.Name = randName(8)
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.ZIndex = 102
    button.Parent = row

    return button, box, check, label
end

local fullbrightBtn, fullbrightBox, fullbrightCheck, fullbrightLabel =
    createCheckbox(checkboxContainer, 0, "Fullbright")

local notifyBtn, notifyBox, notifyCheck, notifyLabel =
    createCheckbox(checkboxContainer, 40, "Notify Entities")

local fovRow = Instance.new("Frame")
fovRow.Name = randName(8)
fovRow.Size = UDim2.new(1, -20, 0, 32)
fovRow.Position = UDim2.new(0, 10, 0, 130)
fovRow.BackgroundTransparency = 1
fovRow.ZIndex = 101
fovRow.Parent = mainFrame

local fovLabel = Instance.new("TextLabel")
fovLabel.Name = randName(7)
fovLabel.Size = UDim2.new(1, -100, 1, 0)
fovLabel.Position = UDim2.new(0, 0, 0, 0)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV 70"
fovLabel.TextColor3 = THEME.textDim
fovLabel.TextSize = 14
fovLabel.Font = FONT
fovLabel.TextXAlignment = Enum.TextXAlignment.Left
fovLabel.ZIndex = 102
fovLabel.Parent = fovRow

local function createSmallButton(parent, position, text)
    local btn = Instance.new("TextButton")
    btn.Name = randName(6)
    btn.Size = UDim2.new(0, 30, 0, 24)
    btn.Position = position
    btn.BackgroundColor3 = THEME.checkboxOff
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = THEME.text
    btn.TextSize = 14
    btn.Font = FONT
    btn.ZIndex = 102
    btn.Parent = parent

    local s = Instance.new("UIStroke")
    s.Color = THEME.accent
    s.Thickness = 1
    s.Parent = btn

    return btn
end

local fovMinus = createSmallButton(fovRow, UDim2.new(1, -100, 0.5, -12), "[-]")
local fovPlus  = createSmallButton(fovRow, UDim2.new(1, -68, 0.5, -12),  "[+]")
local fovReset = createSmallButton(fovRow, UDim2.new(1, -36, 0.5, -12),  "[R]")

local notifyContainer = Instance.new("Frame")
notifyContainer.Name = NAMES.notify
notifyContainer.Size = UDim2.new(0, 260, 0, 400)
notifyContainer.Position = UDim2.new(0, 20, 0.5, 120)
notifyContainer.BackgroundTransparency = 1
notifyContainer.ZIndex = 100
notifyContainer.Parent = screenGui

local notifyLayout = Instance.new("UIListLayout")
notifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifyLayout.Padding = UDim.new(0, 6)
notifyLayout.Parent = notifyContainer

local Fullbright = {}
Fullbright.enabled = false
Fullbright.folder = nil
Fullbright.highlights = {}
Fullbright.scanConnection = nil
Fullbright.removeConnection = nil
Fullbright.refreshConnection = nil

local function shouldHighlight(part)
    if not part:IsA("BasePart") then return false end
    if part.Transparency >= 0.95 then return false end
    local model = part:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChildOfClass("Humanoid") then return false end
    return true
end

local function addHighlight(part)
    if Fullbright.highlights[part] then return end
    if not shouldHighlight(part) then return end

    pcall(function()
        local hl = Instance.new("Highlight")
        hl.Name = randName(10)
        hl.Adornee = part
        hl.FillColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.7
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.OutlineTransparency = 1
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = Fullbright.folder
        Fullbright.highlights[part] = hl
    end)
end

local function removeHighlight(part)
    local hl = Fullbright.highlights[part]
    if hl then
        hl:Destroy()
        Fullbright.highlights[part] = nil
    end
end

local function fullScan()
    for _, d in ipairs(Workspace:GetDescendants()) do
        if d:IsA("BasePart") then
            addHighlight(d)
        end
    end
end

function Fullbright.start()
    if Fullbright.enabled then return end
    Fullbright.enabled = true

    Fullbright.folder = Instance.new("Folder")
    Fullbright.folder.Name = NAMES.hlFolder
    Fullbright.folder.Parent = LocalPlayer:WaitForChild("PlayerGui")

    fullScan()

    Fullbright.scanConnection = Workspace.DescendantAdded:Connect(function(d)
        if not Fullbright.enabled then return end
        if d:IsA("BasePart") then addHighlight(d) end
    end)

    Fullbright.removeConnection = Workspace.DescendantRemoving:Connect(function(d)
        if not Fullbright.enabled then return end
        if d:IsA("BasePart") then removeHighlight(d) end
    end)

    Fullbright.refreshConnection = RunService.Heartbeat:Connect(function()
        if not Fullbright.enabled then return end
        if tick() - (Fullbright._last or 0) < 2 then return end
        Fullbright._last = tick()
        fullScan()
    end)
end

function Fullbright.stop()
    if not Fullbright.enabled then return end
    Fullbright.enabled = false

    if Fullbright.scanConnection then
        Fullbright.scanConnection:Disconnect()
        Fullbright.scanConnection = nil
    end
    if Fullbright.removeConnection then
        Fullbright.removeConnection:Disconnect()
        Fullbright.removeConnection = nil
    end
    if Fullbright.refreshConnection then
        Fullbright.refreshConnection:Disconnect()
        Fullbright.refreshConnection = nil
    end

    for _, hl in pairs(Fullbright.highlights) do
        if hl then hl:Destroy() end
    end
    Fullbright.highlights = {}

    if Fullbright.folder then
        Fullbright.folder:Destroy()
        Fullbright.folder = nil
    end
end

local Notifier = {}
Notifier.enabled = false
Notifier.addedConn = nil
Notifier.removedConn = nil
Notifier.updateConn = nil
Notifier.tracked = {}
Notifier._lastSound = 0
Notifier._lastUpdate = 0

local function playNotifySound()
    pcall(function()
        local sound = Instance.new("Sound")
        sound.Name = NAMES.sound
        sound.SoundId = NOTIFY_SOUND_ID
        sound.Volume = 1
        sound.Parent = SoundService
        sound:Play()
        Debris:AddItem(sound, 5)
    end)
end

local function playNotifySoundThrottled()
    if tick() - Notifier._lastSound < 1 then return end
    Notifier._lastSound = tick()
    playNotifySound()
end

local function matchEntity(objName)
    local lower = objName:lower()
    for displayName, patterns in pairs(ENTITY_MAP) do
        for _, pattern in ipairs(patterns) do
            if lower:find(pattern, 1, true) then
                return displayName
            end
        end
    end
    return nil
end

local function getEntityPosition(entity)
    if entity:IsA("Model") then
        local ok, pivot = pcall(function() return entity:GetPivot() end)
        if ok and pivot then return pivot.Position end
        local pp = entity.PrimaryPart
        if pp then return pp.Position end
        local firstPart = entity:FindFirstChildWhichIsA("BasePart")
        if firstPart then return firstPart.Position end
    elseif entity:IsA("BasePart") then
        return entity.Position
    end
    return nil
end

local function getPlayerPosition()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    return hrp and hrp.Position or nil
end

local function removeTracked(entity)
    local data = Notifier.tracked[entity]
    if data then
        if data.frame and data.frame.Parent then data.frame:Destroy() end
        Notifier.tracked[entity] = nil
    end
end

local function onAdded(obj)
    if not Notifier.enabled then return end
    if Notifier.tracked[obj] then return end
    if not obj:IsA("Model") and not obj:IsA("BasePart") then return end

    if DEBUG_MODE then
        print("[DEBUG] Added: '" .. obj.Name .. "' | " .. obj.ClassName)
    end

    local matched = matchEntity(obj.Name)
    if not matched then return end

    local frame = Instance.new("Frame")
    frame.Name = randName(8)
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = THEME.notifyBg
    frame.BorderSizePixel = 0
    frame.ZIndex = 100
    frame.Parent = notifyContainer

    local stroke = Instance.new("UIStroke")
    stroke.Color = THEME.notifyBorder
    stroke.Thickness = 1
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Name = randName(6)
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "[!] " .. matched
    label.TextColor3 = THEME.text
    label.TextSize = 13
    label.Font = FONT
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.ZIndex = 101
    label.Parent = frame

    Notifier.tracked[obj] = {frame = frame, label = label, displayName = matched}
    playNotifySoundThrottled()
end

local function onRemoved(obj)
    if not Notifier.tracked[obj] then return end
    removeTracked(obj)
end

local function updateDistances()
    local playerPos = getPlayerPosition()
    if not playerPos then return end

    local toRemove = nil
    for entity, data in pairs(Notifier.tracked) do
        if not entity.Parent then
            toRemove = toRemove or {}
            table.insert(toRemove, entity)
        else
            local entPos = getEntityPosition(entity)
            if entPos then
                local dist = math.floor((entPos - playerPos).Magnitude)
                data.label.Text = "[!] " .. data.displayName .. " | " .. dist .. "m"
            end
        end
    end

    if toRemove then
        for _, e in ipairs(toRemove) do
            removeTracked(e)
        end
    end
end

function Notifier.start()
    if Notifier.enabled then return end
    Notifier.enabled = true

    Notifier.addedConn = Workspace.DescendantAdded:Connect(onAdded)
    Notifier.removedConn = Workspace.DescendantRemoving:Connect(onRemoved)
    Notifier.updateConn = RunService.Heartbeat:Connect(function()
        if tick() - Notifier._lastUpdate < 0.1 then return end
        Notifier._lastUpdate = tick()
        updateDistances()
    end)

    for _, d in ipairs(Workspace:GetDescendants()) do
        if d:IsA("Model") or d:IsA("BasePart") then
            task.spawn(onAdded, d)
        end
    end
end

function Notifier.stop()
    if not Notifier.enabled then return end
    Notifier.enabled = false

    if Notifier.addedConn then
        Notifier.addedConn:Disconnect()
        Notifier.addedConn = nil
    end
    if Notifier.removedConn then
        Notifier.removedConn:Disconnect()
        Notifier.removedConn = nil
    end
    if Notifier.updateConn then
        Notifier.updateConn:Disconnect()
        Notifier.updateConn = nil
    end

    for _, data in pairs(Notifier.tracked) do
        if data.frame and data.frame.Parent then data.frame:Destroy() end
    end
    Notifier.tracked = {}
end

local FOVChanger = {}
FOVChanger.value = 70
FOVChanger.original = 70
FOVChanger.active = false
FOVChanger.connection = nil
FOVChanger._last = 0

function FOVChanger.apply(newVal)
    newVal = math.clamp(newVal, 40, 120)

    if not FOVChanger.active then
        local cam = workspace.CurrentCamera
        if cam then
            FOVChanger.original = cam.FieldOfView
        end
        FOVChanger.active = true
        FOVChanger.connection = RunService.Heartbeat:Connect(function()
            if not FOVChanger.active then return end
            if tick() - FOVChanger._last < 0.2 then return end
            FOVChanger._last = tick()
            local c = workspace.CurrentCamera
            if c and math.abs(c.FieldOfView - FOVChanger.value) > 0.5 then
                c.FieldOfView = FOVChanger.value
            end
        end)
    end

    FOVChanger.value = newVal
    fovLabel.Text = "FOV " .. newVal

    local cam = workspace.CurrentCamera
    if cam then cam.FieldOfView = newVal end
end

function FOVChanger.reset()
    FOVChanger.active = false
    if FOVChanger.connection then
        FOVChanger.connection:Disconnect()
        FOVChanger.connection = nil
    end

    local cam = workspace.CurrentCamera
    if cam then
        cam.FieldOfView = FOVChanger.original
    end
    FOVChanger.value = FOVChanger.original
    fovLabel.Text = "FOV " .. FOVChanger.original
end

local function updateCheckbox(box, check, label, enabled)
    if enabled then
        box.BackgroundColor3 = THEME.checkboxOn
        check.TextTransparency = 0
        label.TextColor3 = THEME.text
    else
        box.BackgroundColor3 = THEME.checkboxOff
        check.TextTransparency = 1
        label.TextColor3 = THEME.textDim
    end
end

fullbrightBtn.MouseButton1Click:Connect(function()
    if Fullbright.enabled then
        Fullbright.stop()
        updateCheckbox(fullbrightBox, fullbrightCheck, fullbrightLabel, false)
    else
        Fullbright.start()
        updateCheckbox(fullbrightBox, fullbrightCheck, fullbrightLabel, true)
    end
end)

notifyBtn.MouseButton1Click:Connect(function()
    if Notifier.enabled then
        Notifier.stop()
        updateCheckbox(notifyBox, notifyCheck, notifyLabel, false)
    else
        Notifier.start()
        updateCheckbox(notifyBox, notifyCheck, notifyLabel, true)
    end
end)

fovMinus.MouseButton1Click:Connect(function()
    FOVChanger.apply(FOVChanger.value - 5)
end)

fovPlus.MouseButton1Click:Connect(function()
    FOVChanger.apply(FOVChanger.value + 5)
end)

fovReset.MouseButton1Click:Connect(function()
    FOVChanger.reset()
end)

updateCheckbox(fullbrightBox, fullbrightCheck, fullbrightLabel, false)
updateCheckbox(notifyBox, notifyCheck, notifyLabel, false)

print("[VexHub R&D] Loaded.")
