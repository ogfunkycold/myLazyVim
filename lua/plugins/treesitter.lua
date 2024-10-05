-- NOTE: This section defines the configuration for the Tree-sitter plugin in 
-- LazyVim.  Tree-sitter is a parser generator tool and an incremental parsing
-- library.  The configurations here specify the languages to be supported and 
-- any custom settings for syntax highlighting and code analysis.

-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
-- if true then return {} end
return {
  -- NOTE: add more treesitter parsers
  {
	  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        ensure_installed = {
          "bash",
          "c",
          "cmake",
          -- "cpp",
          "css",
          "gitignore",
          "go",
          "graphql",
          "html",
          "http",
          -- "java",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "query",
          -- "php",
          "python",
          "regex",
          "rust",
          -- "scss",
          "sql",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
        -- matchup = {
        -- 	enable = true,
        -- },
        -- https://github.com/nvim-treesitter/playground#query-linter
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = true, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
          },
        },
      },
      config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)

        -- MDX
        vim.filetype.add({
          extension = {
            mdx = "mdx",
          },
        })
        vim.treesitter.language.register("markdown", "mdx")
      end,
    },
  },
  -- NOTE: since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = function(_, opts)
  --     -- add tsx and treesitter
  --     vim.list_extend(opts.ensure_installed, {
  --       "tsx",
  --       "typescript",
  --     })
  --   end,
  -- },
}
--
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
