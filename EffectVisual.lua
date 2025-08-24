return function()
    -- // Подключаем Fluent GUI (ВАЖНО: грузим ИЗ ОФИЦИАЛЬНОГО РЕПО, не из твоего)
    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

    local Window = Fluent:CreateWindow({
        Title = "Effect visual",
        SubTitle = "By @el_catiraaa <Telegram>",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = false,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    -- // Только одна вкладка Main
    local Tabs = {
        Main = Window:AddTab({ Title = "Main", Icon = "sparkles" })
    }

    -- =========================================================
    -- Стилизация GUI (фиолетовый фон + розовая обводка)
    -- =========================================================
    task.spawn(function()
        task.wait(0.5)
        local CoreGui = game:GetService("CoreGui")
        local screenGui = CoreGui:FindFirstChild("Fluent")
        if screenGui then
            for _, obj in pairs(screenGui:GetDescendants()) do
                if obj:IsA("Frame") or obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    if obj.BackgroundColor3 then
                        obj.BackgroundColor3 = Color3.fromRGB(70, 0, 90)
                    end
                    if obj.BorderSizePixel and obj.BorderSizePixel > 0 then
                        obj.BorderColor3 = Color3.fromRGB(255, 100, 180)
                    end
                end
            end
        end
    end)

    -- =========================================================
    -- // Сервисы
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")
    local player = Players.LocalPlayer

    -- // Хранилище подключений и объектов
    local Connections = {}
    local Objects = {}

    -- =========================================================
    -- 1. Атмосфера
    -- =========================================================
    local function EnableAtmosphere()
        Objects.OriginalLighting = {
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            FogColor = Lighting.FogColor,
            FogStart = Lighting.FogStart,
            FogEnd = Lighting.FogEnd,
            ClockTime = Lighting.ClockTime,
            Brightness = Lighting.Brightness,
            GlobalShadows = Lighting.GlobalShadows
        }

        Lighting.Ambient = Color3.fromRGB(80, 60, 100)
        Lighting.OutdoorAmbient = Color3.fromRGB(50, 40, 70)
        Lighting.FogColor = Color3.fromRGB(60, 50, 90)
        Lighting.FogStart = 0
        Lighting.FogEnd = 500
        Lighting.ClockTime = 14
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end

    local function DisableAtmosphere()
        if Objects.OriginalLighting then
            for k, v in pairs(Objects.OriginalLighting) do
                Lighting[k] = v
            end
        end
    end

    -- =========================================================
    -- 2. Радужная шляпа
    -- =========================================================
    local function EnableHat()
        local char = player.Character or player.CharacterAdded:Wait()
        local head = char:WaitForChild("Head")

        local hat = Instance.new("Part")
        hat.Size = Vector3.new(2, 0.5, 2)
        hat.Anchored = true
        hat.CanCollide = false
        hat.Transparency = 0.3
        hat.Parent = workspace

        local mesh = Instance.new("SpecialMesh", hat)
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://1033714"
        mesh.Scale = Vector3.new(1.5, 1, 1.5)

        local conn = RunService.RenderStepped:Connect(function()
            local t = tick()
            hat.Color = Color3.fromHSV(t % 1, 1, 1)
            hat.CFrame = head.CFrame * CFrame.new(0, 0.83, 0) * CFrame.Angles(0, math.rad(t * 20), 0)
        end)

        Objects.Hat = hat
        Connections.Hat = conn
    end

    local function DisableHat()
        if Connections.Hat then Connections.Hat:Disconnect() end
        if Objects.Hat then Objects.Hat:Destroy() end
    end

    -- =========================================================
    -- 3. Радужные трейлы
    -- =========================================================
    local function rainbowColor(time)
        local r = math.abs(math.sin(time))
        local g = math.abs(math.sin(time + math.pi/3))
        local b = math.abs(math.sin(time + 2*math.pi/3))
        return Color3.fromRGB(r * 255, g * 255, b * 255)
    end

    local function EnableTrails()
        local char = player.Character or player.CharacterAdded:Wait()
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") and (part.Name == "RightHand" or part.Name == "LeftHand") then
                local att0 = Instance.new("Attachment", part)
                local att1 = Instance.new("Attachment", part)
                att1.Position = Vector3.new(0, -0.5, 0)

                local trail = Instance.new("Trail")
                trail.Attachment0 = att0
                trail.Attachment1 = att1
                trail.Lifetime = 0.5
                trail.WidthScale = NumberSequence.new(0.5)
                trail.Transparency = NumberSequence.new(0)
                trail.Parent = part

                local conn = RunService.RenderStepped:Connect(function()
                    trail.Color = ColorSequence.new(rainbowColor(tick()))
                end)

                table.insert(Objects, trail)
                table.insert(Connections, conn)
            end
        end
    end

    local function DisableTrails()
        for _, obj in ipairs(Objects) do
            if typeof(obj) == "Instance" and obj:IsA("Trail") then
                obj:Destroy()
            end
        end
        for _, conn in ipairs(Connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        Objects = {}
        Connections = {}
    end

    -- =========================================================
    -- 4. Эффект прыжка
    -- =========================================================
    local function EnableJumpEffect()
        local char = player.Character or player.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        local root = char:WaitForChild("HumanoidRootPart")

        local conn = humanoid.Jumping:Connect(function()
            local part = Instance.new("Part")
            part.Anchored = true
            part.CanCollide = false
            part.Size = Vector3.new(1,1,1)
            part.Transparency = 0.5
            part.Material = Enum.Material.Neon
            part.Parent = workspace

            local mesh = Instance.new("SpecialMesh", part)
            mesh.MeshType = Enum.MeshType.Sphere
            mesh.Scale = Vector3.new(0.2, 0.05, 0.2)

            part.CFrame = CFrame.new(root.Position - Vector3.new(0, root.Size.Y/2 + 0.05, 0))

            local startTime = tick()
            local rConn
            rConn = RunService.RenderStepped:Connect(function()
                local t = tick() - startTime
                local scale = 0.2 + t*3
                mesh.Scale = Vector3.new(scale, 0.05, scale)
                part.Color = Color3.fromHSV((t*0.7)%1,1,1)
                part.Transparency = math.clamp(0.5 + t,0,1)
                if t > 0.7 then
                    rConn:Disconnect()
                    part:Destroy()
                end
            end)
        end)

        Connections.Jump = conn
    end

    local function DisableJumpEffect()
        if Connections.Jump then Connections.Jump:Disconnect() end
    end

    -- =========================================================
    -- 5. ESP для персонажа
    -- =========================================================
    local function EnableESP()
        local character = player.Character or player.CharacterAdded:Wait()

        local function addHighlight(char)
            if char:FindFirstChild("Highlight") then
                char.Highlight:Destroy()
            end

            local highlight = Instance.new("Highlight")
            highlight.Name = "Highlight"
            highlight.Adornee = char
            highlight.FillTransparency = 1
            highlight.OutlineColor = Color3.fromRGB(180, 0, 255)
            highlight.OutlineTransparency = 0
            highlight.Parent = char
        end

        addHighlight(character)

        Connections.ESP = player.CharacterAdded:Connect(function(char)
            addHighlight(char)
        end)
    end

    local function DisableESP()
        if Connections.ESP then Connections.ESP:Disconnect() end
        local char = player.Character
        if char and char:FindFirstChild("Highlight") then
            char.Highlight:Destroy()
        end
    end

    -- =========================================================
    -- 6. Chams для персонажа (улучшенный)
    -- =========================================================
    local function EnableChams()
        local character = player.Character or player.CharacterAdded:Wait()

        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                if not part:GetAttribute("OriginalMaterial") then
                    part:SetAttribute("OriginalMaterial", part.Material)
                    part:SetAttribute("OriginalTransparency", part.LocalTransparencyModifier)
                end
                part.Material = Enum.Material.Neon
                part.LocalTransparencyModifier = 0.5
            end
        end
    end

    local function DisableChams()
        local character = player.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    local origMat = part:GetAttribute("OriginalMaterial")
                    local origTrans = part:GetAttribute("OriginalTransparency")
                    if origMat then part.Material = origMat end
                    if origTrans then part.LocalTransparencyModifier = origTrans end
                end
            end
        end
    end

    -- =========================================================
    -- GUI элементы
    -- =========================================================
    local MainSection = Tabs.Main:AddSection("Visuals")

    -- Атмосфера
    local AtmosphereToggle = MainSection:AddToggle("Atmosphere", {Title = "Atmosphere", Default = false})
    AtmosphereToggle:OnChanged(function(val)
        if val then EnableAtmosphere() else DisableAtmosphere() end
    end)

    -- Шляпа
    local HatToggle = MainSection:AddToggle("Hat", {Title = "Rainbow Hat", Default = false})
    HatToggle:OnChanged(function(val)
        if val then EnableHat() else DisableHat() end
    end)

    -- Трейлы
    local TrailsToggle = MainSection:AddToggle("Trails", {Title = "Rainbow Trails", Default = false})
    TrailsToggle:OnChanged(function(val)
        if val then EnableTrails() else DisableTrails() end
    end)

    -- Эффект прыжка
    local JumpToggle = MainSection:AddToggle("Jump", {Title = "Jump Effect", Default = false})
    JumpToggle:OnChanged(function(val)
        if val then EnableJumpEffect() else DisableJumpEffect() end
    end)

    -- ESP
    local ESPToggle = MainSection:AddToggle("ESP", {Title = "Local ESP", Default = false})
    ESPToggle:OnChanged(function(val)
        if val then EnableESP() else DisableESP() end
    end)

    -- Chams
    local ChamsToggle = MainSection:AddToggle("Chams", {Title = "Chams", Default = false})
    ChamsToggle:OnChanged(function(val)
        if val then EnableChams() else DisableChams() end
    end)

    -- Автооткрытие GUI
    Window:SelectTab(1)

    Fluent:Notify({
        Title = "Visual Effect",
        Content = "By @el_catiraaa",
        Duration = 5
    })
end
