local Job = require "plenary.job"

---@class status_info
---@field public file_info fun(): string
---@field public git_info fun(): string
---@field public line_info fun(): string
---@field public get_mode fun(config: statusline_config): string
---@field public lsp_info fun(): string
---@field public harpoon_info fun(): string
local status_info = {}


function status_info.file_info()
    local name = vim.api.nvim_buf_get_name(0)

    if not name or name == "" then
        return "[No Name]"
    end

    local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
    local icon = require("nvim-web-devicons").get_icon(file_name, file_ext, { default = true })

    return icon .. " " .. vim.fn.pathshorten(vim.fn.fnamemodify(name, ":."))
end

function status_info.git_info()
    local j = Job:new({
        command = "git",
        args = { "branch", "--show-current" },
        cwd = vim.fn.getcwd()
    })

    local ok, res = pcall(function()
        return vim.trim(j:sync()[1])
    end)

    if ok then
        return string.format("%s %s", require("nvim-web-devicons").get_icon "git", res)
    else
        return "[No Git]"
    end
end

function status_info.line_info()
    return string.format("[%d:%s]", vim.fn.line("."), vim.fn.col("."))
end

function status_info.get_mode(config)
    local mode = vim.fn.mode()

    local mode_table = {
        ["n"] = "Normal ",
        ["i"] = "Insert ",
        ["v"] = "Visual ",
        ["c"] = "Command ",
        ["cv"] = "Command ",
        ["V"] = "Visual ",
        ["␖"] = "Visual ",
        ["t"] = "Terminal ",
    }

    if mode_table[mode] then
        mode = mode_table[mode]
    end

    if mode ~= "Insert " then
        vim.api.nvim_set_hl(0, "Modes", { fg = config.foreground_color, bg = config.background_color })
    else
        vim.api.nvim_set_hl(0, "Modes", { fg = config.background_color, bg = config.foreground_color })
    end

    return mode
end

function status_info.lsp_info()
    local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })

    return string.format("E:%s W:%s H:%s", errors, warnings, hints)
end

function status_info.harpoon_info()
    local hasHarpoon = pcall(require, "harpoon")

    if not hasHarpoon then
        return ""
    end

    local current_file = vim.api.nvim_buf_get_name(0):gsub(vim.fn.getcwd() .. "/", "")
    local marks = require("harpoon"):list().items

    for idx, item in ipairs(marks) do
        if item.value == current_file then
            return tostring(idx)
        end
    end

    return ""
end

return status_info
