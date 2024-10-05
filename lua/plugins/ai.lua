-- NOTE: This file configures various plugins for LazyVim, including Copilot integration 
-- and other related plugins.   It includes settings for enabling/disabling features, 
-- setting up dependencies, and customizing plugin behavior.

-- stylua: ignore
-- if true then return {} end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  {
    -- NOTE: This plugin is the pure lua replacement for github/copilot.vim.
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
        ["*"] = true,
      },
    },
  },
  {
    "nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sources, 1, {
        name = "copilot",
        group_index = 1,
        priority = 100,
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = "copilot.lua",
    opts = {},
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
        user = user:sub(1, 1):upper() .. user:sub(2)
        return {
          auto_insert_mode = true,
          show_help = true,
          question_header = "  " .. user .. " ",
          answer_header = "  Copilot ",
          window = {
            width = 0.4,
          },
          selection = function(source)
            local select = require("CopilotChat.select")
            return select.visual(source) or select.buffer(source)
          end,
        }
      end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- add any opts here
      provider = 'openai',
      mappings = {
        ask = "<leader>ak", -- ask
        edit = "<leader>ae", -- edit
        refresh = "<leader>ar", -- refresh
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  -- NOTE: ChatGPT is a Neovim plugin that allows you to effortlessly utilize
  -- the OpenAI ChatGPT API, empowering you to generate natural language
  -- responses from OpenAI's ChatGPT directly within the editor in response to
  -- your inquiries.
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        -- this config assumes you have OPENAI_API_KEY environment variable set
        openai_params = {
          -- NOTE: model can be a function returning the model name this is 
          -- useful if you want to change the model on the fly using commands
          -- Example:
          -- model = function()
          --     if some_condition() then
          --         return "gpt-4-1106-preview"
          --     else
          --         return "gpt-3.5-turbo"
          --     end
          -- end,
          -- model = "gpt-4-1106-preview",
          model = 'gpt-4o',
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 4095,
          temperature = 0.2,
          top_p = 0.1,
          n = 1,
        }
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  -- {
  --   -- https://github.com/jackMort/ChatGPT.nvim
  --   'jackMort/ChatGPT.nvim',
  --   event = 'VeryLazy',
  --   config = function()
  --     require('chatgpt').setup {
  --       -- NOTE: this config assumes you have OPENAI_API_KEY environment 
  --       -- variable set.
  --       --
  --       -- Default values
  --       -- api_key_cmd = nil,
  --       yank_register = '+',
  --       extra_curl_params = nil,
  --       show_line_numbers = true,
  --       edit_with_instructions = {
  --         diff = false,
  --         keymaps = {
  --           close = '<C-c>',
  --           accept = '<C-y>',
  --           yank = '<C-u>',
  --           toggle_diff = '<C-d>',
  --           toggle_settings = '<C-o>',
  --           toggle_help = '<C-h>',
  --           cycle_windows = '<Tab>',
  --           use_output_as_input = '<C-i>',
  --         },
  --       },
  --       chat = {
  --         welcome_message = WELCOME_MESSAGE,
  --         loading_text = 'Loading, please wait ...',
  --         question_sign = '', -- 🙂
  --         answer_sign = 'ﮧ', -- 🤖
  --         border_left_sign = '',
  --         border_right_sign = '',
  --         max_line_length = 120,
  --         sessions_window = {
  --           active_sign = '  ',
  --           inactive_sign = '  ',
  --           current_line_sign = '',
  --           border = {
  --             style = 'rounded',
  --             text = {
  --               top = ' Sessions ',
  --             },
  --           },
  --           win_options = {
  --             winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
  --           },
  --         },
  --         keymaps = {
  --           close = '<C-c>',
  --           yank_last = '<C-y>',
  --           yank_last_code = '<C-k>',
  --           scroll_up = '<C-u>',
  --           scroll_down = '<C-d>',
  --           new_session = '<C-n>',
  --           cycle_windows = '<Tab>',
  --           cycle_modes = '<C-f>',
  --           next_message = '<C-j>',
  --           prev_message = '<C-k>',
  --           select_session = '<Space>',
  --           rename_session = 'r',
  --           delete_session = 'd',
  --           draft_message = '<C-r>',
  --           edit_message = 'e',
  --           delete_message = 'd',
  --           toggle_settings = '<C-o>',
  --           toggle_sessions = '<C-p>',
  --           toggle_help = '<C-h>',
  --           toggle_message_role = '<C-r>',
  --           toggle_system_role_open = '<C-s>',
  --           stop_generating = '<C-x>',
  --         },
  --       },
  --       popup_layout = {
  --         default = 'center',
  --         center = {
  --           width = '80%',
  --           height = '80%',
  --         },
  --         right = {
  --           width = '30%',
  --           width_settings_open = '50%',
  --         },
  --       },
  --       popup_window = {
  --         border = {
  --           highlight = 'FloatBorder',
  --           style = 'rounded',
  --           text = {
  --             top = ' ChatGPT ',
  --           },
  --         },
  --         win_options = {
  --           wrap = true,
  --           linebreak = true,
  --           foldcolumn = '1',
  --           winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
  --         },
  --         buf_options = {
  --           filetype = 'markdown',
  --         },
  --       },
  --       system_window = {
  --         border = {
  --           highlight = 'FloatBorder',
  --           style = 'rounded',
  --           text = {
  --             top = ' SYSTEM ',
  --           },
  --         },
  --         win_options = {
  --           wrap = true,
  --           linebreak = true,
  --           foldcolumn = '2',
  --           winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
  --         },
  --       },
  --       popup_input = {
  --         prompt = '  ',
  --         border = {
  --           highlight = 'FloatBorder',
  --           style = 'rounded',
  --           text = {
  --             top_align = 'center',
  --             top = ' Prompt ',
  --           },
  --         },
  --         win_options = {
  --           winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
  --         },
  --         submit = '<C-Enter>',
  --         submit_n = '<Enter>',
  --         max_visible_lines = 20,
  --       },
  --       settings_window = {
  --         setting_sign = '  ',
  --         border = {
  --           style = 'rounded',
  --           text = {
  --             top = ' Settings ',
  --           },
  --         },
  --         win_options = {
  --           winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
  --         },
  --       },
  --       help_window = {
  --         setting_sign = '  ',
  --         border = {
  --           style = 'rounded',
  --           text = {
  --             top = ' Help ',
  --           },
  --         },
  --         win_options = {
  --           winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
  --         },
  --       },
  --       -- Configure to use the latest OpenAI model
  --       openai_params = {
  --         -- NOTE: model can be a function returning the model name
  --         -- this is useful if you want to change the model on the fly
  --         -- using commands
  --         -- Example:
  --         -- model = function()
  --         --     if some_condition() then
  --         --         return "gpt-4-1106-preview"
  --         --     else
  --         --         return "gpt-3.5-turbo"
  --         --     end
  --         -- end,
  --         model = 'gpt-4o',
  --         -- model = 'gpt-4o-2024-08-06',
  --         frequency_penalty = 0,
  --         presence_penalty = 0,
  --         max_tokens = 4095,
  --         -- max_tokens = 65536,
  --         temperature = 0.3,
  --         top_p = 0.1,
  --         n = 1,
  --       },
  --       openai_edit_params = {
  --         model = 'gpt-4o',
  --         frequency_penalty = 0,
  --         presence_penalty = 0,
  --         temperature = 0,
  --         top_p = 1,
  --         n = 1,
  --       },
  --       use_openai_functions_for_edits = false,
  --       actions_paths = {},
  --       show_quickfixes_cmd = 'Trouble quickfix',
  --       predefined_chat_gpt_prompts = 'https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv',
  --       highlights = {
  --         help_key = '@symbol',
  --         help_description = '@comment',
  --         params_value = 'Identifier',
  --         input_title = 'FloatBorder',
  --         active_session = 'ErrorMsg',
  --         code_edit_result_title = 'FloatBorder',
  --       },
  --       -- -- Optional settings
  --       -- keymaps = {
  --       --   close = { '<C-c>' },
  --       --   submit = '<C-Enter>',
  --       -- },
  --     }
  --   end,
  --   dependencies = {
  --     'MunifTanjim/nui.nvim',
  --     'nvim-lua/plenary.nvim',
  --     'folke/trouble.nvim',
  --     'nvim-telescope/telescope.nvim',
  --   },
  -- },
  -- -- Custom Parameters (with defaults)
  -- {
  --     "David-Kunz/gen.nvim",
  --     opts = {
  --         model = "mistral", -- The default model to use.
  --         quit_map = "q", -- set keymap for close the response window
  --         retry_map = "<c-r>", -- set keymap to re-send the current prompt
  --         accept_map = "<c-cr>", -- set keymap to replace the previous selection with the last result
  --         host = "localhost", -- The host running the Ollama service.
  --         port = "11434", -- The port on which the Ollama service is listening.
  --         display_mode = "float", -- The display mode. Can be "float" or "split" or "horizontal-split".
  --         show_prompt = false, -- Shows the prompt submitted to Ollama.
  --         show_model = false, -- Displays which model you are using at the beginning of your chat session.
  --         no_auto_close = false, -- Never closes the window automatically.
  --         file = false, -- Write the payload to a temporary file to keep the command short.
  --         hidden = false, -- Hide the generation window (if true, will implicitly set `prompt.replace = true`), requires Neovim >= 0.10
  --         init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
  --         -- Function to initialize Ollama
  --         command = function(options)
  --             local body = {model = options.model, stream = true}
  --             return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
  --         end,
  --         -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
  --         -- This can also be a command string.
  --         -- The executed command must return a JSON object with { response, context }
  --         -- (context property is optional).
  --         -- list_models = '<omitted lua function>', -- Retrieves a list of model names
  --         debug = false -- Prints errors and the command which is run.
  --     }
  -- },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
