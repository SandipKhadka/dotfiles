local cmp = require "cmp"
local luasnip = require "luasnip"

-- Safe check for required plugins
local has_luasnip, luasnip_ok = pcall(require, "luasnip")
if not has_luasnip then
    luasnip_ok = nil
end

-- Kind icons with fallbacks
local kind_icons = {
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "󰒓",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "󰘒",
    Module = "󰏗",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "󰒗",
    Keyword = "󰌋",
    Snippet = "󰑐",
    Color = "󰏘",
    File = "󰈙",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "󰒮",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "󰃭",
    Operator = "󰆕",
    TypeParameter = "󰊄",
    -- Default fallback
    ["default"] = "󰢚",
}

-- Source labels
local source_labels = {
    nvim_lsp = "[LSP]",
    luasnip = "[Snip]",
    buffer = "[Buf]",
    path = "[Path]",
    codeium = "[AI]",
    nvim_lua = "[Lua]",
    ["vim-dadbod-completion"] = "[DB]",
    ["emoji"] = "[Emoji]",
    ["calc"] = "[Calc]",
    ["spell"] = "[Spell]",
    ["latex_symbols"] = "[LaTeX]",
    ["treesitter"] = "[TS]",
    ["crates"] = "[Crates]",
    ["orgmode"] = "[Org]",
}

-- Safe expand function
local function safe_luasnip_expand(args)
    if luasnip_ok then
        luasnip.lsp_expand(args.body)
    else
        vim.notify(
            "LuaSnip not available for snippet expansion",
            vim.log.levels.WARN
        )
    end
end

-- Helper function to check if there are words before cursor
local function has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0
        and vim.api
                .nvim_buf_get_lines(0, line - 1, line, true)[1]
                :sub(col, col)
                :match "%s"
            == nil
end

-- Custom formatter with truncation
local format_function = function(entry, item)
    -- Get kind icon with fallback
    local icon = kind_icons[item.kind] or kind_icons["default"]
    item.kind = " " .. icon .. " "

    -- Get source label with fallback
    local source = entry.source.name
    item.menu = (source_labels[source]
        or "[") .. source:sub(1, 1):upper() .. source:sub(2):sub(1, 3) .. "]"

    -- Truncate long completions
    local max_width = vim.o.columns * 0.4 -- 40% of screen width
    max_width = math.min(max_width, 60) -- Cap at 60 chars
    max_width = math.max(max_width, 30) -- Minimum 30 chars

    if #item.abbr > max_width then
        item.abbr = item.abbr:sub(1, max_width - 3) .. "..."
    end

    -- Add additional info for LSP items when available
    if entry.source.name == "nvim_lsp" and entry.completion_item.detail then
        item.menu = item.menu .. " " .. entry.completion_item.detail
    end

    return item
end

-- Main setup with robust error handling
local status_ok, cmp_ok = pcall(cmp.setup, {
    completion = {
        completeopt = "menu,menuone,preview,noselect",
        keyword_length = 1,
    },

    snippet = {
        expand = function(args)
            safe_luasnip_expand(args)
        end,
    },

    mapping = cmp.mapping.preset.insert {
        -- Navigation
        ["<C-p>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Select,
        },
        ["<C-n>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Select,
        },
        ["<Up>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Insert,
        },
        ["<Down>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Insert,
        },

        -- Scrolling
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-u>"] = cmp.mapping.scroll_docs(-8),
        ["<C-b>"] = cmp.mapping.scroll_docs(8),

        -- Completion control
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-y>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },

        -- Confirm with Enter (with safety)
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },


        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip_ok and luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },

    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = format_function,
        -- Add expandable documentation
        expandable_indicator = true,
    },

    window = {
        completion = {
            border = "rounded",
            winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None",
            scrollbar = true,
        },
        documentation = {
            border = "rounded",
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
            max_width = 80,
            max_height = 20,
        },
    },

    sorting = {
        priority_weight = 2,
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },

    -- Performance options
    performance = {
        -- Debounce trigger events
        throttle = 60,
        -- Fetch completions on trigger characters only
        fetch_timeout = 200,
        -- Max number of completions to show
        max_view_entries = 50,
    },

    -- Experimental features
    experimental = {
        ghost_text = true,
        native_menu = false,
    },

    sources = cmp.config.sources({
        { name = "codeium", group_index = 1, priority = 10 },
        { name = "nvim_lsp", group_index = 1, priority = 8 },
        { name = "luasnip", group_index = 1, priority = 6 },
        { name = "buffer", group_index = 2, priority = 4, keyword_length = 3 },
        { name = "path", group_index = 2, priority = 3 },
    }, {
        { name = "nvim_lua", group_index = 2 },
        { name = "treesitter", group_index = 2 },
        { name = "spell", group_index = 2, keyword_length = 4 },
    }),
})

if not status_ok then
    vim.notify(
        "Failed to setup nvim-cmp: " .. tostring(cmp_ok),
        vim.log.levels.ERROR
    )
end

-- Filetype-specific configurations with merge instead of override
cmp.setup.filetype("html", {
    sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 9 },
        { name = "emmet_ls", priority = 8 },
        { name = "codeium", priority = 7 },
        { name = "luasnip", priority = 5 },
    }, {
        { name = "buffer", priority = 4, keyword_length = 2 },
        { name = "path", priority = 3 },
        { name = "treesitter", priority = 2 },
    }),
})

-- Additional filetype configurations
cmp.setup.filetype("javascript", {
    sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 9 },
        { name = "codeium", priority = 8 },
        { name = "luasnip", priority = 7 },
        { name = "treesitter", priority = 6 },
    }, {
        { name = "buffer", priority = 5 },
        { name = "path", priority = 4 },
    }),
})

cmp.setup.filetype("python", {
    sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 10 },
        { name = "codeium", priority = 8 },
        { name = "luasnip", priority = 7 },
    }, {
        { name = "buffer", priority = 5 },
        { name = "path", priority = 4 },
    }),
})

-- Optional: Keybindings for cmp in command-line mode
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "cmdline" },
    }, {
        { name = "path" },
    }),
})

-- Optional: Keybindings for search mode
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})
