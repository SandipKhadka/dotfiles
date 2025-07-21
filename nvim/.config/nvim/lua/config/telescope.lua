local builtin = require "telescope.builtin"
local map = vim.keymap.set

map("n", "<leader>pv", vim.cmd.Ex)
map("n", "<leader>ff", builtin.find_files, {})
map("n", "<leader>fg", builtin.live_grep, {})
map("n", "<leader>fb", builtin.buffers, {})
map("n", "<leader>fh", builtin.help_tags, {})
map("n", "<C-p>", builtin.git_files, {})
map("n", "gi", builtin.lsp_implementations, {})
map("n", "gr", builtin.lsp_references, {})
map("n", "gd", builtin.lsp_definitions, {})
map("n", "sg", builtin.spell_suggest, {})

require("telescope").setup {

    defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = " ",
        sorting_strategy = "ascending",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
            },
            width = 0.87,
            height = 0.80,
        },
        mappings = {
            n = {
                ["q"] = require("telescope.actions").close,
                ["<C-e>"] = require("telescope.actions").send_to_qflist,
                ["<leader>ff"] = builtin.find_files,
            },

            i = {
                ["<C-e>"] = require("telescope.actions").send_to_qflist,
            },
        },
    },

    extensions_list = { "themes", "terms", "noice" },
    extensions = {
        noice = {},
    },
}
require("telescope").setup {

    defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = " ",
        sorting_strategy = "ascending",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
            },
            width = 0.87,
            height = 0.80,
        },
        mappings = {
            n = {
                ["q"] = require("telescope.actions").close,
                ["<C-e>"] = require("telescope.actions").send_to_qflist,
            },

            i = {
                ["<C-e>"] = require("telescope.actions").send_to_qflist,
            },
        },
    },

    extensions_list = { "themes", "terms", "noice" },
    extensions = {
        noice = {},
    },
}
