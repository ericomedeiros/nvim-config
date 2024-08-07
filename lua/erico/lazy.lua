local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
	'nvim-telescope/telescope-fzf-native.nvim',
	-- NOTE: If you are having trouble with this installation,
	--       refer to the README for telescope-fzf-native for more instructions.
	build = 'make',
	cond = function()
	  return vim.fn.executable 'make' == 1
	end,
      },
    }
  },

  {
    'navarasu/onedark.nvim',
    name = 'onedark',
    config = function()
      vim.cmd('colorscheme onedark')
    end
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ":TSUpdate",
  },

  'ThePrimeagen/harpoon',
  "mbbill/undotree",

  -- Git related plugins
  "tpope/vim-fugitive",
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',


  -- LSP Support
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {'williamboman/mason.nvim'},           -- Optional
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},     -- Required
      {'hrsh7th/cmp-nvim-lsp'}, -- Required
      {'L3MON4D3/LuaSnip'},     -- Required
      {'saadparwaiz1/cmp_luasnip'},

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',

    }
  },
  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
	add = { text = '+' },
	change = { text = '~' },
	delete = { text = '_' },
	topdelete = { text = '‾' },
	changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
	vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

	-- don't override the built-in and fugitive keymaps
	local gs = package.loaded.gitsigns
	vim.keymap.set({'n', 'v'}, ']c', function()
	  if vim.wo.diff then return ']c' end
	  vim.schedule(function() gs.next_hunk() end)
	  return '<Ignore>'
	end, {expr=true, buffer = bufnr, desc = "Jump to next hunk"})
	vim.keymap.set({'n', 'v'}, '[c', function()
	  if vim.wo.diff then return '[c' end
	  vim.schedule(function() gs.prev_hunk() end)
	  return '<Ignore>'
	end, {expr=true, buffer = bufnr, desc = "Jump to previous hunk"})
      end,
    },
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
	icons_enabled = false,
	theme = 'onedark',
	component_separators = '|',
	section_separators = '',
      },
    },
  },
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = "ibl",
    opts = {},
  },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },
  {
    "epwalsh/obsidian.nvim",
    version = "*",  -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
    },

    opts = {
      workspaces = {
	{
	  name = "my-notes",
	  path = "~/vaults/my-vault",
	},
	{
	  name = "work",
	  path = "~/vaults/work",
	},
      },

      daily_notes = {
	-- Optional, if you keep daily notes in a separate directory.
	folder = "dailies",
	-- Optional, if you want to change the date format for the ID of daily notes.
	date_format = "%d-%m-%Y",
	-- Optional, if you want to change the date format of the default alias of daily notes.
	alias_format = "%B %-d, %Y",
	-- Optional, default tags to add to each new daily note created.
	default_tags = { "daily-notes" },
	-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
	template = "daily.md"
      },

      templates = {
	folder = "templates",
	date_format = "%d-%m-%Y",
	time_format = "%H:%M",
      },
    },
  },
})
