local M = {

    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require "config.theme.catppuccin"
        end,
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require "config.theme.rose-pine"
        end,
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },

    {
        "stevearc/dressing.nvim",
        opts = {},
        config = function()
            require("dressing").setup {}
        end,
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "muniftanjim/nui.nvim",
        },
        config = function()
            require "config.tree"
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        config = function()
            require "config.telescope"
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "l3mon4d3/luasnip",
            "saadparwaiz1/cmp_luasnip",
            "j-hui/fidget.nvim",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            require "config.lspconfig"
            require "config.cmp"
            require "config.sniplet"
        end,
    },

    {
        "stevearc/conform.nvim",
        config = function()
            require "config.confirm"
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require "config.tree-sitter"
        end,
    },

    {
        "tpope/vim-fugitive",
    },

    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require "config.git-signs"
        end,
    },

    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")
        end,
    },

    {
        "tpope/vim-commentary",
    },

    {
        "Exafunction/codeium.vim",
    },

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
            require("mason-tool-installer").setup {
                ensure_installed = {
                    "jdtls",
                    "stylua",
                    "lua_ls",
                    "rust_analyzer",
                    "pyright",
                    "clangd",
                    "prettier",
                    "bashls",
                    "html",
                    "cssls",
                    "ts_ls",
                },
            }
        end,
    },

    {
        "folke/trouble.nvim",
        config = function()
            require "config.trouble"
        end,
    },

    {
        "windwp/nvim-ts-autotag",
        config = function()
            require "config.tag"
        end,
    },
}

return M
