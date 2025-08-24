return function()
    -- Подключаем Fluent GUI
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

    -- =========================================================
    -- Сервисы и переменные
    -- =========================================================
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")
    local player = Players.LocalPlayer

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
    -- GUI элементы
    -- =========================================================
    local MainSection = Window:AddTab({ Title = "Main", Icon = "sparkles" }):AddSection("Visuals")

    local AtmosphereToggle = MainSection:AddToggle("Atmosphere", {Title = "Atmosphere", Default = false})
    AtmosphereToggle:OnChanged(function(val)
        if val then EnableAtmosphere() else DisableAtmosphere() end
    end)

    local HatToggle = MainSection:AddToggle("Hat", {Title = "Rainbow Hat", Default = false})
    HatToggle:OnChanged(function(val)
        if val then EnableHat() else DisableHat() end
    end)

    Window:SelectTab(1)

    Fluent:Notify({
        Title = "Visual Effect",
        Content = "By @el_catiraaa",
        Duration = 5
    })
end
