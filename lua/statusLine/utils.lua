local utils = {}

local options = {
  ["FileInfo"] = require("statusLine.statusInfo").getFileInfo(),
  ["ModeInfo"] = require("statusLine.statusInfo").getMode(),
  ["LineInfo"] = require("statusLine.statusInfo").getLineInfo(),
  ["GitInfo"] = require("statusLine.statusInfo").getGitInfo(),
  ["LspInfo"] = require("statusLine.lspInfo").infoCount(),
  ["HarpoonInfo"] = require("statusLine.harpoonInfo").getCurrentMark(),
  -- ["SaveInfo"] = require("statusLine.statusInfo").getSaveInfo()
}

function utils.EnableItem(optionName, optionBool)
  local item
  if optionBool then
    item = options[optionName]
    print(item)
  end

  return item
end

return utils
