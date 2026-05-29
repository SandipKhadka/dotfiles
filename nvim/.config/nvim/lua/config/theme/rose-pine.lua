require("rose-pine").setup {
    variant = "moon",
    dark_variant = "moon",
    dim_inactive_windows = false,
    extend_background_behind_borders = true,

    enable = {
        terminal = true,
        legacy_highlights = true,
        migrations = true,
    },

    styles = {
        bold = true,
        italic = true,
        transparency = true,
    },

    groups = {
        border = "muted",
        link = "iris",
        panel = "surface",
        error = "love",
        hint = "iris",
        info = "foam",
        note = "pine",
        todo = "rose",
        warn = "gold",
        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",
        h1 = "iris",
        h2 = "foam",
        h3 = "rose",
        h4 = "gold",
        h5 = "pine",
        h6 = "foam",
    },

    palette = {},

    highlight_groups = {
        -- Brighter comments (muted → subtle, easier to read)
        Comment = { fg = "subtle", italic = true },
        -- Stronger keywords (pine is the darkest green; very readable)
        Keyword = { fg = "pine", bold = true },
        Statement = { fg = "pine", bold = true },
        Conditional = { fg = "pine", bold = true },
        -- Identifiers and functions more distinct
        Identifier = { fg = "foam" },
        Function = { fg = "rose", bold = true },
        -- Strings pop more clearly
        String = { fg = "gold" },
        -- Types clearly distinct from values
        Type = { fg = "iris", bold = true },
        -- Current line number extra visible
        CursorLineNr = { fg = "rose", bold = true },
        LineNr = { fg = "subtle" },
        -- Cursor stands out more
        Cursor = { fg = "base", bg = "rose" },
        -- Search match more visible
        Search = { fg = "base", bg = "gold", bold = true },
        IncSearch = { fg = "base", bg = "rose", bold = true },
        -- Match parens very clear
        MatchParen = { fg = "rose", bold = true, underline = true },
        -- Diagnostics clearer
        DiagnosticVirtualTextError = { fg = "love", bold = true },
        DiagnosticVirtualTextWarn = { fg = "gold", bold = true },
        DiagnosticVirtualTextInfo = { fg = "foam", bold = true },
        DiagnosticVirtualTextHint = { fg = "iris", bold = true },
    },
    before_highlight = function(group, highlight, palette) end,
}
