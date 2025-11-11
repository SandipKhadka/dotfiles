local M = {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false, -- Load immediately since it's a colorscheme
        config = function()
            require "config.theme.catppuccin"
        end,
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        lazy = false,
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
        event = "VeryLazy", -- Load only when needed
        opts = {},
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
        cmd = "Telescope", -- Load on command
        keys = { -- Load on keymap
            {
                "<leader>ff",
                "<cmd>Telescope find_files<cr>",
                desc = "Find Files",
            },
            {
                "<leader>fg",
                "<cmd>Telescope live_grep<cr>",
                desc = "Live Grep",
            },
        },
        config = function()
            require "config.telescope"
        end,
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" }, -- Load when opening files
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
        event = { "BufWritePre" }, -- Load only before saving
        config = function()
            require "config.confirm"
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" }, -- Load when opening files
        build = ":TSUpdate", -- Ensure treesitter is updated
        config = function()
            require "config.tree-sitter"
        end,
    },

    {
        "tpope/vim-fugitive",
        cmd = { "Git", "Gstatus", "Gblame" }, -- Load on git commands
        config = function()
            require "config.fugitive"
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre", -- Load early for git signs
        config = function()
            require "config.git-signs"
        end,
    },

    {
        "mbbill/undotree",
        cmd = "UndotreeToggle", -- Load only when toggling
        config = function()
            vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")
        end,
    },

    {
        "tpope/vim-commentary",
        keys = { "gc", "gcc" }, -- Load on commentary keys
    },

    {
        "Exafunction/windsurf.vim",
    },

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        event = "VeryLazy", -- Load after UI is ready
        config = function()
            require("mason-tool-installer").setup {
                ensure_installed = {
                    "stylua",
                    "lua_ls",
                    "rust_analyzer",
                    "pyright",
                    "clangd",
                    "prettier",
                    "bashls",
                    "debugpy",
                    "html",
                    "cssls",
                    "black",
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
        ft = {
            "html",
            "xml",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
        }, -- Load only for specific filetypes
        config = function()
            require "config.tag"
        end,
    },

    {
        "mfussenegger/nvim-jdtls",
        ft = { "java" }, -- Load only for Java files
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require "config.java"
        end,
    },

    {
        "rcarriga/nvim-dap-ui",
        ft = { "python", "javascript", "typescript", "java" }, -- Load only for debuggable filetypes
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            require "config.dap"
            require "config.dap-ui"
        end,
    },

    {
        "NvChad/nvim-colorizer.lua",
        event = "BufReadPre", -- Load early for color highlighting
        config = function()
            require("colorizer").setup {
                filetypes = {
                    "css",
                    "scss",
                    "html",
                    "javascript",
                    "typescript",
                    "javascriptreact",
                    "typescriptreact",
                    "lua",
                },
                user_default_options = {
                    RGB = true,
                    RRGGBB = true,
                    names = false, -- Disable color names (faster)
                    tailwind = false, -- Disable tailwind (faster if not using)
                },
            }
        end,
    },
}

return M
