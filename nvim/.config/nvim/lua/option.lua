local o = vim.o
local wo = vim.wo
local opt = vim.opt
local g = vim.g

o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.smartindent = true

o.ignorecase = true
o.smartcase = true
opt.incsearch = true
opt.hlsearch = false
opt.showmatch = true
o.wrapscan = true

o.number = true
o.relativenumber = true
o.numberwidth = 5
wo.cursorline = true
opt.colorcolumn = "80"
opt.signcolumn = "yes"
opt.fillchars = { eob = " " }
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
opt.linespace = 2
o.termguicolors = true

opt.undofile = true
local undodir = os.getenv "HOME" .. "/.vim/undodir"
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
opt.undodir = undodir

opt.backup = false
opt.swapfile = false

o.updatetime = 50
o.lazyredraw = true
o.timeoutlen = 500
opt.hidden = true

opt.spelllang = "en_us"
opt.spell = true

opt.clipboard = "unnamedplus"
opt.mouse = "a"

opt.completeopt = { "menu", "menuone", "noselect" }

g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
