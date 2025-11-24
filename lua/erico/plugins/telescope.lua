return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      "nvim-tree/nvim-web-devicons",
      lazy = true,
      dependencies = { 'nvim-mini/mini.icons', version= '*'  }
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      config = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  }
}

