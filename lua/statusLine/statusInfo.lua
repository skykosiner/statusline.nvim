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

  return string.format("[%d:%s]", line, offset)
end

function statusInfo.getMode()
  -- Every so often this sends an error need to think of a way to fix this
  local mode = vim.fn.mode()

  local mode_table = {
    ["n"] = "Normal ",
    ["i"] = "Insert ",
    ["v"] = "Visual ",
    ["c"] = "Command ",
    ["cv"] = "Command ",
    ["V"] = "Visual ",
    [""] = "Visual ",
    ["t"] = "Terminal ",
  }

  if mode_table[mode] then
    mode = mode_table[mode]
  end

  if mode ~= "Insert " then
    vim.api.nvim_set_hl(0, "Modes", { fg = "#7fa3c0", bg = "#2e2e2e" })
  else
    vim.api.nvim_set_hl(0, "Modes", { fg = "#2e2e2e", bg = "#7fa3c0" })
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
