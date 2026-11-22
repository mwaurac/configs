-- Core editor options (LazyVim-comparable defaults)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable netrw (neo-tree handles directories instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.ignorecase = true
opt.smartcase = true

opt.termguicolors = true
opt.background = "dark"

opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false
opt.backup = false

opt.updatetime = 250
opt.timeoutlen = 300

opt.splitright = true
opt.splitbelow = true

opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.mouse = "a"
opt.confirm = true -- confirm before quitting unsaved buffers (LazyVim behavior)
opt.completeopt = "menu,menuone,noselect"
opt.cmdheight = 0 -- hide the vanilla cmdline (noice popup takes over)
