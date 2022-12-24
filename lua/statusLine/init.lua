local methods = require("statusLine.methods")

local statusLine = {
    setup = methods.Setup
}

print(vim.inspect(methods.Get("ShowItems")))

function statusLine:setStatus()
    vim.o.statusline = '%!v:lua.require("statusline").statusLine.status()'
end

return statusLine
