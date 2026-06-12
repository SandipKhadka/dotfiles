return {
    -- Colorschemes: only active one loads at startup
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        config = function()
            require "config.theme.rose-pine"
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true, -- load only when you :colorscheme catppuccin
        config = function()
            require "config.theme.catppuccin"
        end,
    },

    -- Editing
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- File tree (lazy-loaded on command and key)
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "muniftanjim/nui.nvim",
        },
        config = function()
            require "config.tree"
        end,
    },

    -- Fuzzy finder (lazy-loaded)
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        cmd = "Telescope",
        keys = {
            {
                "<leader>ff",
                "<cmd>Telescope find_files<<cr>",
                desc = "Find files",
            },
            {
                "<leader>fg",
                "<cmd>Telescope live_grep<<cr>",
                desc = "Live grep",
            },
            { "<leader>fb", "<cmd>Telescope buffers<<cr>", desc = "Buffers" },
            {
                "<leader>fh",
                "<cmd>Telescope help_tags<<cr>",
                desc = "Help tags",
            },
            {
                "<leader>fr",
                "<cmd>Telescope oldfiles<<cr>",
                desc = "Recent files",
            },
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require "config.telescope"
        end,
    },

    -- LSP core (lightweight deps only)
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp", -- only needed for capabilities
        },
        config = function()
            require "config.lspconfig"
        end,
    },

    -- Completion (splits heavy deps out of LSP startup path)
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "l3mon4d3/luasnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            require "config.cmp"
            require "config.sniplet"
        end,
    },

    -- LSP status (only starts when LSP attaches)
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {},
    },

    -- Formatting
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = "ConformInfo",
        config = function()
            require "config.confirm"
        end,
    },

    -- Git
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G" },
        keys = {
            { "<leader>gs", "<cmd>Git<<cr>", desc = "Git status" },
        },
        config = function()
            require "config.fugitive"
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require "config.git-signs"
        end,
    },
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = {
            {
                "<leader>u",
                "<cmd>UndotreeToggle<<cr>",
                desc = "Toggle Undotree",
            },
        },
    },
    {
        "tpope/vim-commentary",
        keys = {
            { "gc", mode = { "n", "v" } },
            { "gcc", mode = "n" },
        },
    },

    -- AI
    {
        "Exafunction/windsurf.vim",
    },


    -- Diagnostics (lazy-loaded)
    {
        "folke/trouble.nvim",
        config = function()
            require "config.trouble"
        end,
    },

    -- Autotag
    {
        "windwp/nvim-ts-autotag",
        ft = {
            "html",
            "xml",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
        },
        config = function()
            require "config.tag"
        end,
    },

    -- Java
    {
        "mfussenegger/nvim-jdtls",
        ft = { "java" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require "config.java"
        end,
    },

    -- DAP (command-driven, not filetype-driven)
    {
        "mfussenegger/nvim-dap",
        cmd = { "DapContinue", "DapToggleBreakpoint", "DapTerminate" },
        keys = {
            {
                "<F5>",
                function()
                    require("dap").continue()
                end,
                desc = "DAP Continue",
            },
            {
                "<F9>",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "DAP Breakpoint",
            },
        },
        config = function()
            require "config.dap"
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        cmd = { "DapContinue", "DapToggleBreakpoint" },
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            require "config.dap-ui"
        end,
    },

    -- Colorizer (filetype-only instead of loading on every buffer)
    {
        "NvChad/nvim-colorizer.lua",
        ft = {
            "css",
            "scss",
            "html",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "lua",
        },
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
                    names = false,
                    tailwind = false,
                },
            }
        end,
    },
}
