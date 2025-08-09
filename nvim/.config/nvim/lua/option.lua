local o = vim.o
local g = vim.g
local opt = vim.opt

o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.smartindent = true

o.numberwidth = 5
o.nu = true
o.rnu = true

opt.hlsearch = false
opt.incsearch = true
opt.showmatch = true

opt.undofile = true
vim.opt.undodir = os.getenv "HOME" .. "/.vim/undodir"
opt.backup = false
opt.swapfile = false

opt.wrap = false
opt.shortmess:append "sI"

g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

o.termguicolors = true
opt.colorcolumn = "80"

opt.cursorline = true

opt.fillchars = { eob = " " }
opt.updatetime = 50

opt.spelllang = "en_us"
opt.spell = true
