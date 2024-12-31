local Job = require "plenary.job"

---@class status_info
---@field public file_info fun(): string
---@field public git_info fun(): string
---@field public git_changes fun(): string
---@field public line_info fun(): string
---@field public get_mode fun(config: statusline_config): string
---@field public lsp_info fun(): string
---@field public harpoon_info fun(): string
---@field public custom_info fun(): string
---@field public set_status_custom fun(str: string)
local status_info = {}
local custom = ""

---@param str string
function status_info.set_status_custom(str)
    custom = str
end

---@return string
function status_info.custom_info()
    return custom
end

function status_info.file_info()
    local name = vim.api.nvim_buf_get_name(0)

    if not name or name == "" then
        return "[No Name]"
    end

    local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
    local icon = require("nvim-web-devicons").get_icon(file_name, file_ext, { default = true })

    -- return icon .. " " .. vim.fn.pathshorten(vim.fn.fnamemodify(name, ":."))
    return icon .. " " .. vim.fn.fnamemodify(name, ":.")
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

local parse_shortstat_output = function(s)
    local result = {}

    local insert = { git_insertions:match_str(s) }
    if not vim.tbl_isempty(insert) then
        table.insert(result, string.format("+%s", string.sub(s, insert[1] + 1, insert[2])))
    end

    local changed = { git_changed:match_str(s) }
    if not vim.tbl_isempty(changed) then
        table.insert(result, string.format("~%s", string.sub(s, changed[1] + 1, changed[2])))
    end

    local delete = { git_deletions:match_str(s) }
    if not vim.tbl_isempty(delete) then
        table.insert(result, string.format("-%s", string.sub(s, delete[1] + 1, delete[2])))
    end

    if vim.tbl_isempty(result) then
        return nil
    end

    return string.format("[%s]", table.concat(result, ", "))
end

function status_info.git_changes()
    local j = Job:new({
        command = "git",
        args = { "diff", "--shortstat" },
        cwd = vim.fn.getcwd()
    })

    local ok, res = pcall(function()
        return vim.trim(j:sync()[1])
    end)

    if ok then
        vim.print(parse_shortstat_output(res))
    end
end

function status_info.line_info()
    return string.format("[%d:%s]", vim.fn.line("."), vim.fn.col("."))
end

function status_info.get_mode(config)
    local mode = vim.fn.mode()

    local mode_table = {
        ["n"] = "Normal",
        ["i"] = "Insert",
        ["v"] = "Visual",
        ["c"] = "Command",
        ["cv"] = "Command",
        ["V"] = "Visual",
        ["␖"] = "Visual",
        ["t"] = "Terminal",
    }

    if mode_table[mode] then
        mode = mode_table[mode]
    end

    if mode ~= "Insert" then
        vim.api.nvim_set_hl(0, "Modes", { fg = "#ADB480", bg = "#0B0B08" })
    else
        vim.api.nvim_set_hl(0, "Modes", { fg = config.foreground_color, bg = config.background_color })
    end

    return "[" .. mode .. "]"
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
