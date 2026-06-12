local o = vim.o
local opt = vim.opt

-- Indentation
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.smartindent = true

-- Search
o.ignorecase = true
o.smartcase = true
opt.incsearch = true
opt.hlsearch = false
opt.showmatch = true
o.wrapscan = true

-- Appearance
o.number = true
o.relativenumber = true
o.numberwidth = 5
o.cursorline = true
opt.colorcolumn = "80"
opt.signcolumn = "yes"
opt.fillchars = { eob = " " }
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
opt.linespace = 2
o.termguicolors = true

-- Undo (use stdpath instead of hardcoded HOME)
opt.undofile = true
local undodir = vim.fn.stdpath "data" .. "/undodir"
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
opt.undodir = undodir

opt.backup = false
opt.swapfile = false

-- Performance / Behavior
-- NOTE: removed lazyredraw — it breaks Neovim's UI event loop
o.updatetime = 250 -- 50ms is too aggressive; 250 is fast without burning CPU
o.timeoutlen = 500

-- Spell check (filetype-specific is better than global)
opt.spelllang = "en_us"
-- Uncomment below if you truly want it globally. I added an autocmd for text files instead.
-- opt.spell = true

-- System integration
opt.clipboard = "unnamedplus"
opt.mouse = "a"

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }
