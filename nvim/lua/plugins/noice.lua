-- Cmdline popup + notifications (LazyVim-style `:`, `/`, messages UI)
return {
  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      render = "wrapped-compact",
      stages = "static",
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice last message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice history" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice all messages" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss all" },
      {
        "<C-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<C-f>"
          end
        end,
        silent = true,
        expr = true,
        mode = { "i", "n", "s" },
        desc = "Scroll docs forward",
      },
      {
        "<C-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<C-b>"
          end
        end,
        silent = true,
        expr = true,
        mode = { "i", "n", "s" },
        desc = "Scroll docs back",
      },
    },
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
      },
      messages = { enabled = true, view = "notify", view_error = "notify", view_warn = "notify" },
      popupmenu = { enabled = true, backend = "nui" },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        progress = { enabled = true },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true, -- `/` stays at the bottom like vanilla
        command_palette = true, -- `:` opens centered in a popup
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
    },
  },
}
