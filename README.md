<div align="center">

# statusline.nvim
A small customizable status line written in Lua.

[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)

</div>

# Installation
## Lazy
```lua
{
    "skykosiner/statusline.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons"
    }
}
```
## Packer
```lua
use {
    "skykosiner/statusline.nvim",
    branch = "harpoon2",
    requires = {{"nvim-lua/plenary.nvim"}, {"nvim-tree/nvim-web-devicons" }}
}
```

# Getting started
```lua
require("statusline"):setup {
    background_color = "#2e2e2e",
    foreground_color = "#7fa3c0",
    lsp_info = true,
    harpoon_info = true,
    git_info = true,
    show_icons = true,
}
```

The above config is a very basic config needed to get everything setup
correctly. You can edit the background/foreground color using any hex color
code you want to. Then you can also change certain bits of info being displayed
to true or false. The config above is the default, but you can change
