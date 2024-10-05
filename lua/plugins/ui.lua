-- NOTE: This file configures the user interface (UI) settings for LazyVim.
  -- It includes settings for various UI components such as status lines, tab lines, and other visual elements.
  -- The configurations aim to enhance the visual appearance and usability of the Neovim editor.

-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
-- if true then return {} end

return {
  -- NOTE: Better vim.notify()
  {
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
		},
	},
	-- NOTE: animations
	{
		"echasnovski/mini.animate",
		event = "VeryLazy",
		opts = function(_, opts)
			opts.scroll = {
				enable = false,
			}
		end,
	},
  -- NOTE: 
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = {
			plugins = {
				gitsigns = true,
				tmux = true,
				kitty = { enabled = false, font = "+2" },
			},
		},
		keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
	},
  -- NOTE: the opts function can also be used to change the default opts:
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, "😄")
    end,
  },
  -- NOTE: Status line plugin for Neovim.
	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			local LazyVim = require("lazyvim.util")
			opts.sections.lualine_c[4] = {
				LazyVim.lualine.pretty_path({
					length = 0,
					relative = "cwd",
					modified_hl = "MatchParen",
					directory_hl = "",
					filename_hl = "Bold",
					modified_sign = "",
					readonly_icon = " 󰌾 ",
				}),
			}
		end,
	},
  {
    "nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			local LazyVim = require("lazyvim.util")
      opts.options.theme = "catppuccin"
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
    opts = function()
      -- local dashboard = require 'alpha.themes.dashboard'
      --
      -- local logo = [[
      --     ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
      --     ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
      --     ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
      --     ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
      --     ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
      --     ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
      -- ]]

      local logo = [[
        .-.
       ,  __/   (
        , '-.____\
          u=='/  \
            /_/  \
          .-''   |
          (  ____/_____
          _>_/.--------
          \///
          //
          //
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          -- stylua: ignore
          center = {
            { action = 'lua LazyVim.pick()()',                           desc = " Find File",       icon = " ", key = "f" },
            { action = "ene | startinsert",                              desc = " New File",        icon = " ", key = "n" },
            { action = 'lua LazyVim.pick("oldfiles")()',                 desc = " Recent Files",    icon = " ", key = "r" },
            { action = 'lua LazyVim.pick("live_grep")()',                desc = " Find Text",       icon = " ", key = "g" },
            { action = 'lua LazyVim.pick.config_files()()',              desc = " Config",          icon = " ", key = "c" },
            { action = 'lua require("persistence").load()',              desc = " Restore Session", icon = " ", key = "s" },
            { action = "LazyExtras",                                     desc = " Lazy Extras",     icon = " ", key = "x" },
            { action = "Lazy",                                           desc = " Lazy",            icon = "󰒲 ", key = "l" },
            { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit",            icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- open dashboard after closing lazy
      if vim.o.filetype == "lazy" then
        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(vim.api.nvim_get_current_win()),
          once = true,
          callback = function()
            vim.schedule(function()
              vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
            end)
          end,
        })
      end

      return opts
    end,
  },
  -- NOTE: Twilight is a Lua plugin for Neovim 0.5 that dims inactive portions of the code you're editing.
  -- Not performant so only enable when needed
  {
    'folke/twilight.nvim',
    opts = {
      dimming = {
        inactive = true, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
      },
      context = 20, -- amount of lines we will try to show around the current line
      treesitter = true, -- use treesitter when available for the filetype
    },
    keys = {
      {
        '<leader>tw',
        '<cmd>Twilight<cr>',
        desc = 'Toggle twilight',
      },
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
