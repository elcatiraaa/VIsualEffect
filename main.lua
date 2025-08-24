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

    -- 👉 сюда вставляешь всё: Atmosphere, Trails, Hat, ESP, Chams, Jump и создание кнопок GUI
    -- (всё то, что у тебя занимало ~300 строк)

    -- Автооткрытие GUI
    Window:SelectTab(1)

    Fluent:Notify({
        Title = "Visual Effect",
        Content = "By @el_catiraaa",
        Duration = 5
    })
end
