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
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

-- Common on_attach function for keymaps and commands
local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, silent = true }
    
    -- Keymaps
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
    vim.keymap.set("n", "<leader>f", function() 
        vim.lsp.buf.format { async = true } 
    end, vim.tbl_extend("force", opts, { desc = "Format" }))
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostic" }))
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = "Diagnostic loclist" }))
    
    -- Enable inlay hints if supported (Neovim 0.10+)
    if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
    
    -- Highlight symbol under cursor
    if client.server_capabilities.documentHighlightProvider then
        local group = vim.api.nvim_create_augroup("LSPDocumentHighlight", { clear = false })
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
    if client.supports_method "textDocument/semanticTokens" then
        client.server_capabilities.semanticTokensProvider = nil
    end
end

-- Enhanced capabilities with nvim-cmp support
local capabilities = vim.lsp.protocol.make_client_capabilities()

local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
    capabilities = cmp_lsp.default_capabilities(capabilities)
else
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
            javascript = {
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

-- Setup all LSP servers (except jdtls which is handled separately)
for server, config in pairs(servers) do
    vim.lsp.config(server, config)
end

-- Enable all configured LSP servers (except jdtls)
vim.lsp.enable {
    "html",
    "cssls",
    "ts_ls",
    "pyright",
    "clangd",
    "rust_analyzer",
    "bashls",
    "lua_ls",
}

-- ============================================================================
-- JDTLS Configuration (Java)
-- ============================================================================
-- JDTLS is configured separately via ftplugin/java.lua because it requires
-- special initialization and project-specific settings

-- Create ftplugin directory if it doesn't exist
local ftplugin_dir = vim.fn.stdpath "config" .. "/ftplugin"
if vim.fn.isdirectory(ftplugin_dir) == 0 then
    vim.fn.mkdir(ftplugin_dir, "p")
end

-- Write JDTLS configuration to ftplugin/java.lua
local jdtls_config = [[-- ============================================================================
-- Java LSP (JDTLS) Configuration - Auto-generated
-- ============================================================================

-- Check if we're in a Java project
local function is_java_project()
    local root_markers = { "gradlew", "mvnw", "pom.xml", "build.gradle", "build.gradle.kts" }
    for _, marker in ipairs(root_markers) do
        if vim.fn.findfile(marker, vim.fn.expand "%:p:h" .. ";") ~= "" then
            return true
        end
    end
    return false
end

if not is_java_project() then
    return
end

local ok, jdtls = pcall(require, "jdtls")
if not ok then
    return
end

local ok_setup, jdtls_setup = pcall(require, "jdtls.setup")
if not ok_setup then
    return
end

-- Path configuration
local jdtls_path = vim.fn.stdpath "data" .. "/mason/packages/jdtls"

if vim.fn.isdirectory(jdtls_path) == 0 then
    vim.notify("JDTLS not installed. Run :MasonInstall jdtls", vim.log.levels.WARN)
    return
end

local config_path = jdtls_path .. "/config_"
if vim.fn.has "mac" == 1 then
    config_path = config_path .. "mac"
elseif vim.fn.has "unix" == 1 then
    config_path = config_path .. "linux"
else
    config_path = config_path .. "win"
end

local jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
if jar == "" then
    return
end

-- Project root
local root_markers = { "gradlew", ".git", "mvnw", "pom.xml", "build.gradle" }
local root_dir = jdtls_setup.find_root(root_markers) or vim.fn.getcwd()
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath "cache" .. "/jdtls-workspace/" .. project_name

-- Capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
    capabilities = cmp_lsp.default_capabilities(capabilities)
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- On attach
local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, silent = true }
    
    -- Standard LSP keymaps
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    
    -- Java-specific keymaps
    vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, vim.tbl_extend("force", opts, { desc = "Organize imports" }))
    vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, vim.tbl_extend("force", opts, { desc = "Extract variable" }))
    vim.keymap.set("v", "<leader>jv", function() jdtls.extract_variable { visual = true } end, opts)
    vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, vim.tbl_extend("force", opts, { desc = "Extract constant" }))
    vim.keymap.set("v", "<leader>jm", function() jdtls.extract_method { visual = true } end, opts)
    vim.keymap.set("n", "<leader>jtc", jdtls.test_class, vim.tbl_extend("force", opts, { desc = "Test class" }))
    vim.keymap.set("n", "<leader>jtm", jdtls.test_nearest_method, vim.tbl_extend("force", opts, { desc = "Test method" }))
    
    -- DAP setup
    jdtls.setup_dap { hotcodereplace = "auto" }
    jdtls.setup.add_commands()
end

-- Settings
local settings = {
    java = {
        eclipse = { downloadSources = true },
        configuration = { updateBuildConfiguration = "interactive" },
        maven = { downloadSources = true },
        implementationsCodeLens = { enabled = true },
        referencesCodeLens = { enabled = true },
        references = { includeDecompiledSources = true },
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
        completion = {
            favoriteStaticMembers = {
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "org.mockito.Mockito.*",
            },
            filteredTypes = { "com.sun.*", "java.awt.*", "jdk.*", "sun.*" },
            importOrder = { "java", "javax", "com", "org" },
        },
        sources = {
            organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
            },
        },
        codeGeneration = {
            toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
        },
        inlayHints = {
            parameterNames = { enabled = "all" },
        },
    },
}

-- Bundles
local init_options = {
    bundles = {},
    extendedClientCapabilities = extendedClientCapabilities,
}

local java_debug_bundle = vim.fn.glob(
    vim.fn.stdpath "data" .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
    1
)
if java_debug_bundle ~= "" then
    table.insert(init_options.bundles, java_debug_bundle)
end

local java_test_bundles = vim.split(
    vim.fn.glob(vim.fn.stdpath "data" .. "/mason/packages/java-test/extension/server/*.jar", 1),
    "\n"
)
if #java_test_bundles > 0 then
    vim.list_extend(init_options.bundles, java_test_bundles)
end

-- Config
local config = {
    cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx1g",
        "-Xms256m",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", jar,
        "-configuration", config_path,
        "-data", workspace_dir,
    },
    root_dir = root_dir,
    settings = settings,
    init_options = init_options,
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
        allow_incremental_sync = true,
        debounce_text_changes = 150,
    },
}

vim.fn.mkdir(workspace_dir, "p")
jdtls.start_or_attach(config)
]]

-- Write the ftplugin file
local java_ftplugin = io.open(ftplugin_dir .. "/java.lua", "w")
if java_ftplugin then
    java_ftplugin:write(jdtls_config)
    java_ftplugin:close()
end

-- ============================================================================
-- Diagnostic Configuration
-- ============================================================================
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
    Error = "",
    Warn  = "",
    Hint  = "",
    Info  = "",
}

vim.diagnostic.config {
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = signs.Error,
            [vim.diagnostic.severity.WARN]  = signs.Warn,
            [vim.diagnostic.severity.INFO]  = signs.Info,
            [vim.diagnostic.severity.HINT]  = signs.Hint,
        },
    },
}
