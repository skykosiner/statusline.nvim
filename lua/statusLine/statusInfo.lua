local statusInfo = {}

function statusInfo.getFileInfo()
    local name = vim.api.nvim_buf_get_name(0)

    if not name or name == "" then
        return "[No Name]"
    end

    local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
    local icon = require("nvim-web-devicons").get_icon(file_name, file_ext, { default = true })

    local fileName = vim.fn.pathshorten(vim.fn.fnamemodify(name, ":."))
    fileName = icon .. " " .. fileName

    return fileName
end

local function getGitIcon()
    return require("nvim-web-devicons").get_icon ".gitattributes"
end

function statusInfo.getGitInfo()
    local git_branch = vim.fn["FugitiveHead"]()

    if not git_branch or git_branch == "" then
        git_branch = "[No Git]"
    else
        git_branch = " %s " .. git_branch
        git_branch = string.format(git_branch, getGitIcon())
    end

    return git_branch
end

function statusInfo.getLineInfo()
    local line = vim.fn.line(".")
    local offset = vim.fn.col(".")

    local nonDouble = {
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true,
        [5] = true,
        [6] = true,
        [7] = true,
        [8] = true,
        [9] = true
    }

    if nonDouble[offset] then
        offset = "0" .. offset
    end

    return string.format("[%d:%s]", line, offset)
end

function statusInfo.getMode()
    local mode = vim.fn.mode()

    local mode_table = {
        ["n"] = "Normal",
        ["i"] = "Insert",
        ["v"] = "Visual",
        ["c"] = "Command",
        ["cv"] = "Command",
        ["V"] = "Visual",
        [""] = "Visual",
    }

    if mode_table[mode] then
        mode = mode_table[mode]
    end

    if mode == "Insert" then
        vim.cmd([[highlight Modes guifg=#F2F2F2]])
    else
        vim.cmd([[highlight Modes guifg=#373b40 guibg=#7fa3c0]])
    end

    return mode
end

function statusInfo.getFileType()
    local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
    local icon = require 'nvim-web-devicons'.get_icon(file_name, file_ext, { default = true })
    local filetype = vim.bo.filetype

    if filetype == '' then return "(no filetype)" end
    return string.format(" %s %s ", icon, filetype):lower()
end

return statusInfo
