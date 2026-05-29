-- ~/.config/nvim/lua/plugins/dapui-config.lua
-- or add directly to your init.lua

require("dapui").setup({
    layouts = {
        {
            elements = {
                "scopes",      -- Variables in current scope
                "breakpoints", -- All breakpoints
                "stacks",      -- Call stack
                "watches",     -- Watch expressions
            },
            size = 40,
            position = "left",
        },
        {
            elements = {
                "repl",        -- Debug console
            },
            size = 10,
            position = "bottom",
        },
    },
    
    -- Auto close UI when debugging stops
    auto_close = true,
    
    -- Hide empty panels
    hide_inactive = true,
    
    -- Simple icons
    icons = {
        expanded = "▼",
        collapsed = "▶",
        current_frame = "→",
    },
    
    -- Key mappings inside debug windows
    mappings = {
        expand = "<CR>",
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
    },
})
