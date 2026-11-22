-- Themes: gruvbox dark (default) + kanagawa on demand.
-- Switch with `:colorscheme kanagawa-wave|kanagawa-dragon|kanagawa-lotus`.
-- (lualine uses theme "auto", so the statusline follows the colorscheme.)
return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = { strings = true, emphasis = true, comments = true, operators = false, folds = true },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      inverse = true,
      contrast = "soft", -- "hard" | "soft" | ""
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.o.background = "dark"
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    -- lazy-loaded on first `:colorscheme kanagawa-*` (lazy.nvim resolves
    -- colorschemes on demand).
    opts = {
      compile = false,
      theme = "wave", -- default dark flavor for `:colorscheme kanagawa`
      background = { dark = "wave", light = "lotus" },
    },
  },
}
