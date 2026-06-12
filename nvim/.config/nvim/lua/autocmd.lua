local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local grp = augroup("UserConfig", { clear = true })

-- LSP keymaps (added missing gd/gr/gi)
autocmd("LspAttach", {
    group = grp,
    callback = function(args)
        local buf = args.buf
        local opts = { buffer = buf, silent = true }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set(
            { "v", "n" },
            "<leader>ca",
            vim.lsp.buf.code_action,
            opts
        )
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("i", "<C-g>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "]d", function()
            vim.diagnostic.jump { count = 1, float = true }
        end, opts)
        vim.keymap.set("n", "[d", function()
            vim.diagnostic.jump { count = -1, float = true }
        end, opts)
    end,
})

-- Highlight on yank
autocmd("TextYankPost", {
    group = grp,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank { higroup = "IncSearch", timeout = 150 }
    end,
})

-- Guarded auto-save
autocmd({ "InsertLeave", "FocusLost" }, {
    group = grp,
    pattern = "*",
    callback = function(args)
        local buf = args.buf
        local bo = vim.bo[buf]
        if
            bo.modified
            and not bo.readonly
            and bo.modifiable
            and bo.buftype == ""
        then
            vim.api.nvim_buf_call(buf, function()
                vim.cmd "silent! write"
            end)
        end
    end,
})

-- Enable spell check only for text files (remove if you want it globally)
autocmd("FileType", {
    group = grp,
    pattern = { "markdown", "text", "gitcommit" },
    callback = function()
        vim.opt_local.spell = true
    end,
})
