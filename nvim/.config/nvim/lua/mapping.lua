vim.g.mapleader = " "
local map = vim.keymap.set

map("n", "<leader>d", '"_d')
map("v", "<leader>d", '"_d')
map("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

map("n", "<leader>ds", vim.diagnostic.setloclist)

map("n", "<leader>j", "<CMD>cnext<CR>zz")
map("n", "<leader>k", "<CMD>cprev<CR>zz")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-m>", "<C-w>x")
map("n", "<C-w>", "<cmd>bd<CR>")
map("n", "<C-o>", "<C-w>o>")

map("n", "<C-Up>", ":resize +2<CR>", { silent = true })
map("n", "<C-Down>", ":resize -2<CR>", { silent = true })
map("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true })
map("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true })

map("n", "<tab>", "<CMD>bn<CR>", { silent = true })
map("n", "<S-tab>", "<CMD>bp<CR>", { silent = true })

map("n", "<leader>fm", function()
    require("conform").format { lsp_fallback = true }
end)

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzz")
map("n", "N", "Nzz")

map("i", "<C-b>", "<ESC>^i")
map("i", "<C-e>", "<End>")
map("i", "<C-h>", "<Left>")
map("i", "<C-l>", "<Right>")
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")

map("n", "J", "mzJ`z")
map("v", "J", ":move '>+1<CR>gv=gv")
map("v", "K", ":move '<-2<CR>gv=gv")

map("n", "<leader>n", "<cmd>set nu!<CR>")
map("n", "<leader>rl", "<cmd>set rnu!<CR>")

map("n", "<Esc>", "<cmd>noh<CR>")

map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

map("n", "<A-h>", ":split<CR>")
map("n", "<A-v>", ":vsplit<CR>")

map("n", "<leader>y", '"+y')
map("v", "<leader>y", '"+y')
map("n", "<leader>Y", '"+Y')
map("n", "<leader>p", '"+p')
map("v", "<leader>p", [["_d"+P]], { noremap = true, silent = true })

map("n", "<leader>P", '"+P')

map("n", "Q", "<cmd>q!<CR>")
map("i", "<A-q>", "<Esc>")
map("n", "<C-a>", "ggVG")

map("n", "<leader>o", "<CMD>normal o<CR>")
map("n", "<leader>O", "<CMD>normal O<CR>")

map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
