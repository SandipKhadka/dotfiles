local map = vim.keymap.set

-- Search/replace word under cursor
map("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<<Left><Left><Left>")

-- Diagnostics
map(
    "n",
    "<leader>ds",
    vim.diagnostic.setloclist,
    { desc = "Diagnostic loclist" }
)

-- Quickfix
map("n", "<leader>j", "<cmd>cnext<<cr>zz")
map("n", "<leader>k", "<cmd>cprev<<cr>zz")

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")

-- CRITICAL FIX: <C-m> IS Enter (carriage return). Your old map broke Enter.
-- Changed to <leader>x for window swap.
map("n", "<leader>x", "<C-w>x", { desc = "Swap with next window" })

-- Save (if modified) and close buffer
map("n", "<C-w>", function()
    if not vim.bo.readonly and vim.bo.modifiable and vim.bo.modified then
        vim.cmd "w"
    end
    vim.cmd "bd"
end, { desc = "Save & close buffer" })

-- Close other windows
map("n", "<C-o>", "<C-w>o", { desc = "Close other windows" })

-- Resize
map("n", "<C-Up>", ":resize +2<<cr>", { silent = true })
map("n", "<C-Down>", ":resize -2<<cr>", { silent = true })
map("n", "<C-Left>", ":vertical resize -2<<cr>", { silent = true })
map("n", "<C-Right>", ":vertical resize +2<<cr>", { silent = true })

-- Buffer navigation
map("n", "<tab>", "<cmd>bn<cr>", { silent = true })
map("n", "<S-tab>", "<cmd>bp<cr>", { silent = true })

-- Formatting
map("n", "<leader>fm", function()
    require("conform").format { lsp_fallback = true }
end, { desc = "Format buffer" })

-- Centered movement
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Insert mode navigation
map("i", "<C-b>", "<ESC>^i")
map("i", "<C-e>", "<End>")
map("i", "<C-h>", "<Left>")
map("i", "<C-l>", "<Right>")
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")

-- Join / move lines
map("n", "J", "mzJ`z")
map("v", "J", ":move '>+1<<CR>gv=gv")
map("v", "K", ":move '<-2<<CR>gv=gv")

-- Toggles
map("n", "<leader>n", "<cmd>set nu!<cr>")
map("n", "<leader>rl", "<cmd>set rnu!<cr>")

-- Clear search highlight
map("n", "<Esc>", "<cmd>noh<<cr>")

-- Increment/decrement
map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

-- Splits
map("n", "<A-h>", ":split<<cr>")
map("n", "<A-v>", ":vsplit<<cr>")

-- Clipboard
map({ "n", "v" }, "<leader>y", '"+y')
map("n", "<leader>Y", '"+Y')
map({ "n", "v" }, "<leader>p", '"+p')
map("n", "<leader>P", '"+P')
map("v", "<leader>p", [["_d"+P]], { noremap = true, silent = true })


-- Quick quit / escape
map("n", "Q", "<cmd>q!<cr>")
map("i", "<A-q>", "<Esc>")

-- Select all
map("n", "<C-a>", "ggVG")

-- Insert lines via leader (noremap avoids recursion)
map("n", "<leader>o", "o", { noremap = true })
map("n", "<leader>O", "O", { noremap = true })

-- Make normal delete commands use black hole register
map({ "n", "v" }, "d", '"_d')
map({ "n", "v" }, "dd", '"_dd')
map({ "n", "v" }, "D", '"_D')
map({ "n", "v" }, "x", '"_x')
map({ "n", "v" }, "X", '"_X')

-- Leader + delete = copy to register (normal delete behavior)
map({ "n", "v" }, "<leader>d", 'd')
map({ "n", "v" }, "<leader>dd", 'dd')
map({ "n", "v" }, "<leader>x", 'x')
map({ "n", "v" }, "<leader>X", 'X')
map({ "n", "v" }, "<leader>D", 'D')
