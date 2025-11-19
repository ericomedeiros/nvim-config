-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true
vim.o.winborder = "rounded"

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.splitright = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Decrease update time
vim.opt.timeoutlen = 200
vim.opt.updatetime = 150

vim.opt.colorcolumn = "120"

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Enable break indent
vim.opt.breakindent = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Set completeopt to have a better completion experience
vim.opt.completeopt = {'menuone','noselect'}

-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true

vim.opt.conceallevel = 1
