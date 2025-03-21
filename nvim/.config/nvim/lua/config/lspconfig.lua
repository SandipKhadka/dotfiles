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

require("lspconfig").jdtls.setup {
    capabilities = capabilities,
    on_init = on_init,
}

require("lspconfig").html.setup {
    capabilities = capabilities,
    on_init = on_init,
}

require("lspconfig").cssls.setup {
    capabilities = capabilities,
    on_init = on_init,
    filetypes = { "html", "javascript", "css" },
}

require("lspconfig").ts_ls.setup {
    capabilities = capabilities,
    on_init = on_init,
    filetypes = { "javascript", "typescript", "html", "typescriptreact" },
}

require("lspconfig").pyright.setup {
    capabilities = capabilities,
    on_init = on_init,
}

require("lspconfig").clangd.setup {
    capabilities = capabilities,
    on_init = on_init,
}

require("lspconfig").bashls.setup {
    capabilities = capabilities,
    on_init = on_init,

    bashIde = {
        globPattern = "*@(.sh|.inc|.bash|.command)",
    },
}

require("lspconfig").lua_ls.setup {
    capabilities = capabilities,
    on_init = on_init,

    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
}
