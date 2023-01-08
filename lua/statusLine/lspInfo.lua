local lspInfo = {}

function lspInfo.infoCount()
    local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })

    return string.format("E:%s W:%s H:%s", errors, warnings, hints)
end

return lspInfo
