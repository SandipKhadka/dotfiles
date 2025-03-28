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
