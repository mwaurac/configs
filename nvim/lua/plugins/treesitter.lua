-- Treesitter (nvim-treesitter `main` branch rewrite).
-- The legacy `master` branch is frozen and incompatible with Neovim 0.12's
-- query API (it errored on every markdown buffer). The rewrite needs:
-- Neovim 0.12+, a C compiler, and the `tree-sitter` CLI for :TSUpdate
-- (sudo pacman -S tree-sitter-cli). No lazy-loading is supported.
-- NOTE: the rewrite dropped incremental selection and legacy textobjects.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({})

      local langs = {
        "bash",
        "c",
        "cpp",
        "html",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
      }
      -- Install missing parsers in the background (no-op if present).
      ts.install(langs)

      -- Enable highlight + indent wherever a parser exists for the filetype.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("custom_treesitter", { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang then
            return
          end
          if not pcall(vim.treesitter.language.add, lang) then
            return
          end
          pcall(vim.treesitter.start, ev.buf)
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
