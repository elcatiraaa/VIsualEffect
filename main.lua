return function()
    -- // Подключаем Fluent GUI
    local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/elcatiraaa/VIsualEffect/main/main.lua"))()

    local Window = Fluent:CreateWindow({
        Title = "Effect visual",
        SubTitle = "By @el_catiraaa <Telegram>",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = false,
        Theme = "Dark", 
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    -- ⬇️ весь твой код, который ты скинул, вставляется сюда БЕЗ изменений
    -- ...
    -- ...
    -- конец скрипта

    Fluent:Notify({
        Title = "Visual Effect",
        Content = "By @el_catiraaa",
        Duration = 5
    })
end
