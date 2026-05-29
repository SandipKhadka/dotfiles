local cmp = require "cmp"
cmp.setup {
    completion = {
        completeopt = "menu,menuone",
    },

    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },

    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),

        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },

        ["<Tab>"] = cmp.mapping(function(fallback)
            if require("luasnip").jumpable() then
                require("luasnip").jump(1)
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
                require("luasnip").jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },

    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, item)
            local kind_icons = {
                Text = "󰉿",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰜢",
                Variable = "󰀫",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "󰑭",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "󰈇",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "󰙅",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "󰊄",
            }
            local source_labels = {
                nvim_lsp = "[LSP]",
                luasnip = "[Snip]",
                buffer = "[Buf]",
                path = "[Path]",
                codeium = "[AI]",
            }
            item.kind = " " .. (kind_icons[item.kind] or "?") .. " "
            item.menu = source_labels[entry.source.name] or ""
            -- truncate long completions so menu stays readable
            if #item.abbr > 40 then
                item.abbr = item.abbr:sub(1, 37) .. "..."
            end
            return item
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    sources = cmp.config.sources({
        { name = "codeium" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }, {
        { name = "buffer" },
    }),
}

-- custom for html file type
cmp.setup.filetype("html", {
    sources = cmp.config.sources {
        { name = "nvim_lsp", priority = 1 }, -- Higher priority for LSP completion
        { name = "codeium", priority = 3 },
        { name = "luasnip", priority = 0 },
        { name = "buffer", priority = 3 },
        { name = "path", priority = 4 },
    },
})
