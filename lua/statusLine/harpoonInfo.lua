local harpoonInfo = {}

function harpoonInfo:getCurrentMark()
    local status = require("harpoon.mark").status()

    if status == "" then
        status = "N"
    end

    return string.format("H:%s", status)
end

return harpoonInfo
