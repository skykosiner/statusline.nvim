local status_info = require "statusline.status_info"
---@class statusline_config
---@field public background_color string
---@field public foreground_color string
---@field public lsp_info boolean
---@field public harpoon_info boolean
---@field public git_info boolean

---@class statusline
---@field public config statusline_config
---@field public setup fun(self: statusline, config: statusline_config): statusline
---@field public set_status fun()
local statusline = {}
statusline.__index = statusline

---@return statusline
function statusline:new()
  return setmetatable({
    config = {
      background_color = "#2e2e2e",
      foreground_color = "#7fa3c0",
      lsp_info = true,
      harpoon_info = true,
      git_info = true,
    }
  }, self)
end

local new_statusline = statusline:new()

---@param self statusline
---@param config statusline_config
---@return statusline
function statusline.setup(self, config)
  if config ~= nil then
    self.config = config
    new_statusline.config = config
  end

  return self
end

function statusline.set_status()
  vim.o.statusline = '%!v:lua.Status()'
end

---@param item string
---@return string
local function enable_item(item)
  local map = {
    ["lsp_info"] = new_statusline.config.lsp_info,
    ["harpoon_info"] = new_statusline.config.harpoon_info,
    ["git_info"] = new_statusline.config.git_info,
  }

  local map_item_to_function = {
    ["lsp_info"] = status_info.lsp_info(),
    ["harpoon_info"] = status_info.harpoon_info(),
    ["git_info"] = status_info.git_info(),
  }

  if map[item] then
    return map_item_to_function[item]
  end

  return ""
end

function Status()
  vim.api.nvim_set_hl(0, "Ignore",
    { bg = new_statusline.config.background_color, fg = new_statusline.config.foreground_color })

  local statusline_str = "%%#Modes#" .. "%s" .. "%%#Ignore# " .. "%s %s %s %s %s %s %s"

  return string.format(statusline_str,
    status_info.get_mode(new_statusline.config),
    enable_item("lsp_info"),
    "%=",
    status_info.file_info(),
    enable_item("harpoon_info"),
    "%=",
    enable_item("git_info"),
    status_info.line_info()
  )
end

return new_statusline
