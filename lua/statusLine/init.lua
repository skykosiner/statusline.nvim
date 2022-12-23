local methods = require("methods")

local statusLine = {
    setup = methods.Setup
}

print(methods.Get("ShowItems"))

function statusLine:setStatus()
    vim.o.statusline = '%!v:lua.require("statusline").statusLine.status()'
end

return statusLine
