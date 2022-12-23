local statusInfo = require("statusInfo.statusInfo")
local statusLine = {}

local statusline = "%%#Modes#" ..
    " %s%%)" .. "%%#Ignore#" .. "%s%% %s%%)  %%-5.100(%s%%) %s%%  %%-5.20(%s%%)%%-6.6)"

function statusLine:status()
    return string.format(statusline,
        statusInfo.getMode(statusInfo),
        statusInfo.getGitInfo(statusInfo),
        "%=",
        statusInfo.getFileType(statusInfo),
        "%=",
        statusInfo.getLineInfo(statusInfo))
end

function statusLine:setStatus()
    vim.o.statusline = '%!v:lua.require("statusline").statusLine.status()'
end

return statusLine
