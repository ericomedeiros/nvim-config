return {
  "olimorris/codecompanion.nvim",
  opts = {
    strategies = {
      chat = {
        adapter = "cerebras",
      },
      inline = {
        adapter = "cerebras",
      },
    },
    adapters = {
      http = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = {
              api_key = "GEMINI_KEY",
            },
          })
        end,
        cerebras = function ()
          return require("codecompanion.adapters").extend("openai_compatible", {
            name = "cerebras",
            formatted_name = "Cerebras",
            env = {
              url = "https://api.cerebras.ai",
              api_key = "CEREBRAS_KEY",
              chat_url = "/v1/chat/completions",
            },
            opts = {
              stream = false,
              log_level = "INFO"
            },
            schema = {
              model = { default = "llama-3.3-70b" },
              max_completion_tokens = { default = 1024 },
            },
          })
        end
      },
    },
    opts = {
      log_level = "INFO"
    },
  },
  -- dependencies = {
  --   "nvim-lua/plenary.nvim",
  --   "ravitemer/mcphub.nvim",
  --   {
  --     "MeanderingProgrammer/render-markdown.nvim",
  --     ft = { "markdown", "codecompanion" }
  --   },
  --   {
  --     "OXY2DEV/markview.nvim",
  --     lazy = false,
  --     opts = {
  --       preview = {
  --         filetypes = { "markdown", "codecompanion" },
  --         ignore_buftypes = {},
  --       },
  --     },
  --   },
  --   {
  --     "echasnovski/mini.diff",
  --     config = function()
  --       local diff = require("mini.diff")
  --       diff.setup({
  --         -- Disabled by default
  --         source = diff.gen_source.none(),
  --       })
  --     end,
  --   },
  -- },
}
