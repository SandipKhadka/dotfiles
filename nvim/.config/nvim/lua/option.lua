local o = vim.o -- global options
local wo = vim.wo -- window-local options
local opt = vim.opt -- more flexible options setter
local g = vim.g -- global variables

-- ======================
-- === Indentation & Tabs
-- ======================
o.expandtab = true -- Use spaces instead of tabs
o.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
o.tabstop = 4 -- Number of spaces tabs count for
o.softtabstop = 4 -- Number of spaces a tab counts for while editing
o.smartindent = true -- Smart autoindenting when starting a new line

-- ======================
-- === Search Settings
-- ======================
o.ignorecase = true -- Case-insensitive searching...
o.smartcase = true -- ... unless uppercase letter used
opt.incsearch = true -- Show search matches as you type
opt.hlsearch = false -- Highlight search matches (off by default)
opt.showmatch = true -- Briefly jump to matching bracket
o.wrapscan = true -- Wrap searches around file

-- ======================
-- === UI Settings
-- ======================
o.number = true -- Show absolute line numbers
o.relativenumber = true -- Show relative line numbers
o.numberwidth = 5 -- Width of the line number column
wo.cursorline = true -- Highlight the current line
opt.colorcolumn = "80" -- Highlight column 80
opt.signcolumn = "yes" -- Always show the sign column to prevent text shifting
opt.fillchars = { eob = " " } -- Remove ~ from empty lines
opt.wrap = false -- Disable line wrapping
opt.scrolloff = 8 -- Keep 8 lines visible above/below cursor
opt.sidescrolloff = 8 -- Keep 8 columns visible left/right of cursor
o.termguicolors = true -- Enable 24-bit RGB colors

-- ======================
-- === Undo, Backup & Swap
-- ======================
opt.undofile = true -- Enable persistent undo
local undodir = os.getenv "HOME" .. "/.vim/undodir"
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
opt.undodir = undodir -- Set undo directory

opt.backup = false -- Disable backup files
opt.swapfile = false -- Disable swap files

-- ======================
-- === Performance & Behavior
-- ======================
o.updatetime = 50 -- Faster completion & CursorHold events
o.lazyredraw = true -- Faster macro execution & screen redrawing
o.timeoutlen = 500 -- Key sequence timeout length (ms)
opt.hidden = true -- Allow buffer switching without saving

-- ======================
-- === Spell Checking
-- ======================
opt.spelllang = "en_us" -- Spell checking language
opt.spell = true -- Enable spell checking globally

-- ======================
-- === Clipboard & Mouse
-- ======================
opt.clipboard = "unnamedplus" -- Use system clipboard for copy/paste
opt.mouse = "a" -- Enable mouse support in all modes

-- ======================
-- === Completion Options
-- ======================
opt.completeopt = { "menu", "menuone", "noselect" } -- Better completion experience

-- ======================
-- === Disable Unused Providers for Performance
-- ======================
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
