require("dapui").setup {
    layouts = {
        {
            elements = {
                { id = "scopes", size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
        },
        {
            elements = {
                { id = "repl", size = 0.5 },
                { id = "console", size = 0.5 },
                -- Add "controls" if you use it
                -- { id = "controls", size = 0.1 },
            },
            size = 10,
            position = "bottom",
        },
    },
    controls = {
        enabled = false, -- or true if you want a UI control panel
        element = "repl", -- which UI element to show controls in
        icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
        },
    },
}
