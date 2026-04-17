-- Setup plugins
require("fidget").setup {}
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = {
        "lua_ls",
        "jdtls",
        "html",
        "cssls",
        "ts_ls",
        "pyright",
        "clangd",
        "rust_analyzer",
        "bashls",
    },
    automatic_installation = true,
}

-- Common LSP handlers for better error messages and UI
local handlers = {
    ["textDocument/hover"] = function()
        return vim.lsp.buf.hover { border = "rounded" }
    end,

    ["textDocument/signatureHelp"] = function()
        return vim.lsp.buf.signature_help { border = "rounded" }
    end,
}

-- Common on_attach function for keymaps and commands
local on_attach = function(client, bufnr)
    -- Enable inlay hints if supported (Neovim 0.10+)
    if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- Highlight symbol under cursor
    if client.server_capabilities.documentHighlightProvider then
        local group = vim.api.nvim_create_augroup(
            "LSPDocumentHighlight",
            { clear = false }
        )
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            group = group,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = bufnr,
            group = group,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

-- Common on_init function
local on_init = function(client, _)
    -- Disable semantic tokens if not needed (can cause performance issues)
    if client.supports_method "textDocument/semanticTokens" then
        client.server_capabilities.semanticTokensProvider = nil
    end
end

-- Enhanced capabilities with nvim-cmp support
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Check if cmp_nvim_lsp is available
local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
    capabilities = cmp_lsp.default_capabilities(capabilities)
else
    -- Fallback to manual configuration
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
end

-- Base config that all servers inherit
local base_config = {
    capabilities = capabilities,
    on_attach = on_attach,
    on_init = on_init,
    handlers = handlers,
}

-- Helper function to merge configs
local function make_config(opts)
    return vim.tbl_deep_extend("force", base_config, opts or {})
end

-- LSP server configurations
local servers = {
    html = make_config {},

    cssls = make_config {
        filetypes = { "css", "scss", "less" },
    },

    ts_ls = make_config {
        filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
        },
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
        },
    },

    pyright = make_config {
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = "basic",
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "workspace",
                },
            },
        },
    },

    clangd = make_config {
        cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
        },
    },

    rust_analyzer = make_config {
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy",
                },
                cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true,
                },
                procMacro = {
                    enable = true,
                },
                diagnostics = {
                    enable = true,
                    disabled = { "unresolved-proc-macro" },
                    enableExperimental = true,
                },
            },
        },
    },

    bashls = make_config {
        filetypes = { "sh", "bash" },
        settings = {
            bashIde = {
                globPattern = "*@(.sh|.inc|.bash|.command)",
            },
        },
    },

    lua_ls = make_config {
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
                hint = {
                    enable = true,
                },
            },
        },
    },
}

-- Setup all LSP servers
for server, config in pairs(servers) do
    vim.lsp.config(server, config)
end

-- Enable all configured LSP servers
vim.lsp.enable {
    "html",
    "cssls",
    "tsserver",
    "pyright",
    "clangd",
    "rust_analyzer",
    "bashls",
    "lua_ls",
    "jdtls",
}

-- Configure diagnostics
vim.diagnostic.config {
    virtual_text = {
        prefix = "●",
        source = "if_many",
    },
    float = {
        source = "if_many",
        border = "rounded",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
}
-- Diagnostic signs
local signs = {
    Error = "",  -- fancy X for errors
    Warn  = "",  -- triangle warning
    Hint  = "",  -- lightbulb
    Info  = "",  -- info circle
}

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = signs.Error,
      [vim.diagnostic.severity.WARN]  = signs.Warn,
      [vim.diagnostic.severity.INFO]  = signs.Info,
      [vim.diagnostic.severity.HINT]  = signs.Hint,
    },
  },
})
