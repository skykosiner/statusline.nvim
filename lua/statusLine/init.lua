local methods     = require("statusLine.methods")
local statusInfo  = require("statusLine.statusInfo")
local lspInfo     = require("statusLine.lspInfo")
local harpoonInfo = require("statusLine.harpoonInfo")

local statusLine = {
    setup = methods.Setup
}

-- print(vim.inspect(methods.Get("ShowItems")))

function status()
    local statusline = "%%#Modes#" .. " %s" .. "%%#Ignore# " .. "%s %s %s %s %s %s %s "
    return string.format(statusline,
        statusInfo.getMode(),
        lspInfo.infoCount(),
        "%=",
        statusInfo.getFileInfo(),
        harpoonInfo.getCurrentMark(),
        "%=",
        statusInfo.getGitInfo(),
        statusInfo.getLineInfo()
    )
end

function statusLine:setStatus()
    vim.o.statusline = '%!v:lua.status()'

    local colors = {
        ["backgroundColor"] = methods.Get("colors")["backgroundColor"],
        ["textColor"] = methods.Get("colors")["textColor"]
    }

    vim.api.nvim_set_hl(0, "Ignore", { bg = colors["backgroundColor"], fg = colors["textColor"] })
end

return statusLine
