-- Editor essentials: which-key, git, autopairs, comments, formatting
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>h", group = "harpoon" },
        { "<leader>b", group = "buffers" },
        { "<leader>c", group = "code" },
        { "<leader>C", group = "crates" },
        { "<leader>f", group = "find" },
        { "<leader>q", group = "quit/session" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics" },
        { "<leader>g", group = "git" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
        { "<leader>sn", group = "noice" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer keymaps",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local map = function(mode, keys, fn, desc)
          vim.keymap.set(mode, keys, fn, { buffer = bufnr, desc = desc })
        end
        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Prev hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gb", function()
          gs.blame_line({ full = true })
        end, "Blame line")
        map("n", "<leader>gd", gs.diffthis, "Diff")
      end,
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { check_ts = true },
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    keys = {
      { "gcc", desc = "Comment line" },
      { "gc", mode = { "n", "v" }, desc = "Comment" },
    },
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true })
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local ignore = { c = true, cpp = true } -- clangd handles C/C++
        if ignore[vim.bo[bufnr].filetype] then
          return nil
        end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        rust = { "rustfmt" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },
  {
    "echasnovski/mini.surround",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    -- Defaults: sa add, sd delete, sr replace, sf/SF find, sh highlight.
    -- e.g. `saiw)` surrounds word with parens, `sd'` removes quotes.
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo comments" },
    },
  },
}
