local map = vim.keymap.set
require("neo-tree").setup {
    window = {
        position = "left",
        width = 30,
        mappings = {
            ["P"] = {
                "toggle_preview",
                config = { use_float = false, use_image_nvim = true },
            },
        },
    },
}

map("n", "<C-n>", ":Neotree toggle<CR>", { noremap = true, silent = true })
map("n", "<C-l>", ":Neotree reveal<CR>", { noremap = true, silent = true })
