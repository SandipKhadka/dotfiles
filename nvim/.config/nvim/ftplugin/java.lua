-- ============================================================================
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
