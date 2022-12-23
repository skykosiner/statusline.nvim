local settings = require("")
local methods = {}

function methods.Setup(update)
    settings = setmetatable(update, { __index = settings })
end

function methods.Get(key)
    return settings[key]
end

return methods
