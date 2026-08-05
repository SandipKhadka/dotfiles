vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable providers early (before any lazy loading)
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_ruby_provider = 0

require "config.lazy"
require "mapping"
require "option"
require "autocmd"

vim.cmd.colorscheme "rose-pine"
vim.opt.mouse = ""

