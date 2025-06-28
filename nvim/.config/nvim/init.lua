require("config.lazy")
require("config.colorscheme")
require("config.keymaps")
require("config.lsp")

vim.opt.guicursor = ""
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.conceallevel = 1
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- highlight search
vim.opt.incsearch = true
vim.opt.backspace = "indent,eol,start"

vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2 -- Check with vim-sleuth
vim.opt.tabstop = 2
vim.opt.expandtab = true

vim.opt.cursorline = true
vim.opt.title = true
vim.opt.list = true
vim.opt.fileformats = "unix"

-- vim.opt.swapfile = false
-- vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Spell checking options
vim.opt.spell = true
vim.opt.spelllang = "en_us"
vim.opt.spellsuggest = "best,10"

vim.opt.encoding = "utf-8"
vim.opt.colorcolumn = "80,100,120"

-- Set highlight on search
vim.opt.hlsearch = true

-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode
vim.opt.mouse = "a"

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 250
vim.wo.signcolumn = "yes"

-- Softwrap
vim.o.wrap = false
vim.o.scrolloff = 8

-- Remove trailing spaces on save: replaces by conform
--vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--  pattern = { "*" },
--  command = [[%s/\s\+$//e]],
--})

-- Enable copy to system clipboard
vim.opt.clipboard = "unnamedplus"
vim.o.termguicolors = true

vim.opt.fillchars:append({
	vert = "▕", -- Vertical separator
	fold = "·", -- Fold column filler
	diff = "╱", -- Diff filler
})

vim.o.timeoutlen = 500
vim.g.have_nerd_font = true
--[[
--]]
