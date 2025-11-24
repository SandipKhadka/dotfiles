local autocmd = vim.api.nvim_create_autocmd

-- Your existing LspAttach keymaps
autocmd("LspAttach", {
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover()
        end, opts)
        vim.keymap.set("n", "<leader>ws", function()
            vim.lsp.buf.workspace_symbol() -- fixed typo here ("workleader_symbol" -> "workspace_symbol")
        end, opts)
        vim.keymap.set("n", "<leader>vd", function()
            vim.diagnostic.open_float()
        end, opts)
        vim.keymap.set("n", "<leader>gD", function()
            vim.lsp.buf.declaration()
        end, opts)
        vim.keymap.set({ "v", "n" }, "<leader>ca", function()
            vim.lsp.buf.code_action()
        end, opts)
        vim.keymap.set("n", "<leader>rn", function()
            vim.lsp.buf.rename()
        end, opts)
        vim.keymap.set("i", "<C-g>", function()
            vim.lsp.buf.signature_help()
        end, opts)
        vim.keymap.set("n", "[d", function()
            vim.diagnostic.jump ({ count = 1, float = true })
        end, opts)
        vim.keymap.set("n", "]d", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, opts)
    end,
})

-- Format on save with conform
-- autocmd("BufWritePre", {
--     pattern = "*",
--     callback = function(args)
--         require("conform").format { bufnr = args.buf }
--     end,
-- })

-- Highlight yank
autocmd("TextYankPost", {
    pattern = "*",
    command = "lua vim.highlight.on_yank({higroup='IncSearch', timeout=150})",
})

-- Auto-save on InsertLeave and FocusLost
autocmd({ "InsertLeave", "FocusLost" }, {
    pattern = "*",
    callback = function()
        vim.cmd "silent! write"
    end,
})
