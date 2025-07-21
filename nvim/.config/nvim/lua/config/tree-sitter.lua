require("nvim-treesitter.configs").setup {
    ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
    },

    sync_install = false,
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        use_languagetree = true,

        disable = function(lang, buf)
            -- if lang == "html" then
            --     print "html is disabled thank you"
            --     return true
            -- end

            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats =
                pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                print "tresittor is disabled for large files"
                return true
            end
        end,
    },

    indent = {
        disable = { "lua", "javascript", "yaml" },
        enable = true,
    },
}
