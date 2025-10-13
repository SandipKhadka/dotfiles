require("fidget").setup {}
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = {
        "lua_ls",
        "jdtls",
    },
}

local on_init = function(client, _)
    if client.supports_method "textDocument/semanticTokens" then
        client.server_capabilities.semanticTokensProvider = nil
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    },
}

vim.lsp.config("jdtls", {
    capabilities = capabilities,
    on_init = on_init,
})

vim.lsp.config("html", {
    capabilities = capabilities,
    on_init = on_init,
})

vim.lsp.config("cssls", {
    capabilities = capabilities,
    on_init = on_init,
    filetypes = { "html", "javascript", "css" },
})

vim.lsp.config("tsserver", {
    capabilities = capabilities,
    on_init = on_init,
    filetypes = { "jav)ascript", "typescript", "html", "typescriptreact" },
})

vim.lsp.config("pyright", {
    capabilities = capabilities,
    on_init = on_init,
})

vim.lsp.config("clangd", {
    capabilities = capabilities,
    on_init = on_init,
})

vim.lsp.config("rust_analyzer", {
    capabilities = capabilities,
    on_init = on_init,
})
vim.lsp.config("bashls", {
    capabilities = capabilities,
    on_init = on_init,

    bashIde = {
        globPattern = "*@(.sh|.inc|.bash|.command)",
    },
})

vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    on_init = on_init,

    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
})
