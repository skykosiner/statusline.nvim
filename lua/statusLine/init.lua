local methods = require("statusLine.methods")
local statusInfo = require("statusLine.statusInfo")

local statusLine = {
    setup = methods.Setup
}

-- print(vim.inspect(methods.Get("ShowItems")))

function status()
    local statusline = "%s %s %s %s"
    return string.format(statusline,
        statusInfo.getMode(),
        statusInfo.getGitInfo(),
        statusInfo.getFileType(),
        statusInfo.getLineInfo()
    )
end

function statusLine:setStatus()
    vim.o.statusline = '%!v:lua.status()'
end

return statusLine
