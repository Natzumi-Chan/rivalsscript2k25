local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local player = game.Players.LocalPlayer
local LuaName = "KeyAuth Lua Example"

--* Configuration *--
local initialized = false
local sessionid = ""

--* Application Details *--
local name = "private fn"         --* Nom de l'application
local ownerid = "3DTIrNzIzx"      --* ID du propriétaire
local version = "1.3"             --* Version de l'application

--* GUI Setup *--
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

-- Main Frame for the Cheat UI (invisible by default)
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 850, 0, 450)
mainFrame.Position = UDim2.new(0.5, -425, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false -- Initially hidden

-- Title for mainFrame
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(0, 388, 0, 30)  -- Change la largeur ici (300)
titleLabel.Text = "Private FN - Cheat Interface"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 24

mainFrame.Size = UDim2.new(0, 390, 0, 450)  -- Change la taille de la mainFrame si nécessaire


-- License Key Frame (Initial Screen)
local licenseFrame = Instance.new("Frame", screenGui)
licenseFrame.Size = UDim2.new(0, 400, 0, 250)
licenseFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
licenseFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
licenseFrame.BorderSizePixel = 0
licenseFrame.Visible = true -- Initially visible

local licenseLabel = Instance.new("TextLabel", licenseFrame)
licenseLabel.Size = UDim2.new(1, 0, 0, 40)
licenseLabel.Text = "Enter License Key"
licenseLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
licenseLabel.BackgroundTransparency = 1
licenseLabel.Font = Enum.Font.SourceSansBold
licenseLabel.TextSize = 40

local licenseTextBox = Instance.new("TextBox", licenseFrame)
licenseTextBox.Size = UDim2.new(0, 350, 0, 50)
licenseTextBox.Position = UDim2.new(0, 25, 0, 50)
licenseTextBox.PlaceholderText = "Enter your license key here"
licenseTextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
licenseTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
licenseTextBox.Font = Enum.Font.SourceSans
licenseTextBox.TextSize = 24  -- Augmenter la taille du texte ici

local validateButton = Instance.new("TextButton", licenseFrame)
validateButton.Size = UDim2.new(0, 350, 0, 50)
validateButton.Position = UDim2.new(0, 25, 0, 120)
validateButton.Text = "Validate License"
validateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
validateButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

-- Function to validate license
validateButton.MouseButton1Click:Connect(function()
    local LicenseKey = licenseTextBox.Text
    if LicenseKey == "" then
        StarterGui:SetCore("SendNotification", {
            Title = LuaName,
            Text = "Error: License key is empty.",
            Duration = 3
        })
        return false
    end

    -- Initializing Application
    local req = game:HttpGet('https://keyauth.win/api/1.1/?name=' .. HttpService:UrlEncode(name) .. '&ownerid=' .. HttpService:UrlEncode(ownerid) .. '&type=init&ver=' .. HttpService:UrlEncode(version))
    if req == "KeyAuth_Invalid" then 
        print("Error: Application not found.")
        StarterGui:SetCore("SendNotification", {
            Title = LuaName,
            Text = "Error: Application not found.",
            Duration = 3
        })
        return false
    end
    local data = HttpService:JSONDecode(req)

    if data.success == true then
        initialized = true
        sessionid = data.sessionid
    elseif (data.message == "invalidver") then
        print("Error: Wrong application version.")
        StarterGui:SetCore("SendNotification", {
            Title = LuaName,
            Text = "Error: Wrong application version.",
            Duration = 3
        })
        return false
    else
        print("Error: " .. data.message)
        return false
    end

    -- Licensing Request
    local req = game:HttpGet('https://keyauth.win/api/1.1/?name=' .. HttpService:UrlEncode(name) .. '&ownerid=' .. HttpService:UrlEncode(ownerid) .. '&type=license&key=' .. HttpService:UrlEncode(LicenseKey) .. '&ver=' .. HttpService:UrlEncode(version) .. '&sessionid=' .. sessionid)
    local data = HttpService:JSONDecode(req)

    if data.success == false then
        StarterGui:SetCore("SendNotification", {
            Title = LuaName,
            Text = "Error: " .. data.message,
            Duration = 5
        })
        return false
    end

    StarterGui:SetCore("SendNotification", {
        Title = LuaName,
        Text = "License Validated Successfully!",
        Duration = 5
    })

    -- Hide the license frame and show the main cheat UI
    licenseFrame.Visible = false
    mainFrame.Visible = true
end)

-- Helper: Create Buttons inside the main cheat UI
local function createFeatureButton(title, url)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 350, 0, 40)
    button.Text = title
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 20
    button.Parent = mainFrame

    button.MouseButton1Click:Connect(function()
        -- Logic to handle the feature toggle or activation
        print("Activating: " .. title)
        -- Assuming we are going to load the feature from Pastebin
        local featureCode = game:HttpGet(url)
        loadstring(featureCode)()
    end)

    return button
end

-- Create all the feature buttons in the mainFrame
local buttonYPosition = 60 -- starting Y position for the first button

-- Aimbot
local aimbotButton = createFeatureButton("Aimbot", "https://pastebin.com/raw/KQQSgQ3X")
aimbotButton.Position = UDim2.new(0, 25, 0, buttonYPosition)
buttonYPosition = buttonYPosition + 50

-- Wallhack (ESP)
local espButton = createFeatureButton("WallHack (ESP)", "https://pastebin.com/raw/3jx2QTEn")
espButton.Position = UDim2.new(0, 25, 0, buttonYPosition)
buttonYPosition = buttonYPosition + 50

-- Fly
local flyButton = createFeatureButton("Fly", "https://pastebin.com/raw/Tca0Ba2r")
flyButton.Position = UDim2.new(0, 25, 0, buttonYPosition)
buttonYPosition = buttonYPosition + 50

-- Speed Hack
local speedButton = createFeatureButton("Speed Hack", "https://pastebin.com/raw/cAk02VLi")
speedButton.Position = UDim2.new(0, 25, 0, buttonYPosition)
buttonYPosition = buttonYPosition + 50

-- Enemy Rotation
local enemyRotationButton = createFeatureButton("Enemy Rotation", "https://pastebin.com/raw/cF2ThJbk")
enemyRotationButton.Position = UDim2.new(0, 25, 0, buttonYPosition)
buttonYPosition = buttonYPosition + 50
