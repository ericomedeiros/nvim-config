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
      acp = {
        opts = {
          show_defaults = false,
        },
      },
      http = {
        opts = {
          show_defaults = false,
        },
        copilot = function ()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "gpt-4.1",
              },
            },
          })
        end,
        openrouter = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://openrouter.ai/api",
              api_key = "OPENROUTER_KEY",
              chat_url = "/v1/chat/completions",
            },
            schema = {
              model = {
                default = "x-ai/grok-4.1-fast",
              },
            },
          })
        end,
        groq = function ()
          return require("codecompanion.adapters").extend("openai_compatible", {
            name = "groq",
            formatted_name = "Groq",
            env = {
              url = "https://api.groq.com/openai",
              api_key = "GROQ_KEY",
              chat_url = "/v1/chat/completions",
            },
            opts = {
              stream = true,
            },
            schema = {
              model = { default = "openai/gpt-oss-20b" },
              max_completion_tokens = { default = 8192 },
            },
          })
        end,
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
  extensions = {
     mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        make_vars = true,
        make_slash_commands = true,
        show_result_in_chat = true
      }
    }
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ravitemer/mcphub.nvim",
    "zbirenbaum/copilot.lua",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown", "codecompanion" }
    },
    {
      "OXY2DEV/markview.nvim",
      lazy = false,
      opts = {
        preview = {
          filetypes = { "markdown", "codecompanion" },
          ignore_buftypes = {},
        },
      },
    },
    {
      "echasnovski/mini.diff",
      config = function()
        local diff = require("mini.diff")
        diff.setup({
          -- Disabled by default
          source = diff.gen_source.none(),
        })
      end,
    },
  },
}
