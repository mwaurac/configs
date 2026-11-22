-- Markdown preview (markview.nvim)
return {
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<leader>p",
        function()
          require("markview").toggle()
        end,
        desc = "Toggle markdown preview",
      },
    },
    opts = {
      preview = {
        modes = { "n", "no", "c" },
        hybrid_modes = { "i" },
      },
      markdown = {
        headings = { enable = true },
        code_blocks = { enable = true },
        block_quotes = { enable = true },
        list_items = { enable = true },
        horizontal_rules = { enable = true },
        tables = { enable = true },
      },
    },
  },
}