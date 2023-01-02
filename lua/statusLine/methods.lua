local methods = {}

local settings = {
    ShowItems = {
        FileInfo = true,
        ModeInfo = true,
        LineInfo = true,
        GitInfo = false,
        LspInfo = false,
        HarpoonInfo = false,
        SaveInfo = false,
    },
    colors = {
        backgroundColor = "#7fa3c0",
        textColor = "#373b40",
    },
}

function methods.Setup(config)
    -- TODO: Make the table actually update the settings table
    settings = setmetatable(config, { __index = settings })
    -- print(vim.inspect(settings))
end

function methods.Get(key)
    return settings[key]
end

return methods
