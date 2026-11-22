-- Open tabs (bufferline) + statusline (lualine)
return {
  {
    -- Safe buffer removal (LazyVim-style): replaces the window's buffer with
    -- the alternate/empty one instead of raw bdelete, so closing a tab can
    -- never leave a window showing a special buffer (which cascaded into
    -- neo-tree closing the sidebar and quitting nvim).
    "echasnovski/mini.bufremove",
    version = "*",
    keys = {
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete(0, false)
        end,
        desc = "Delete buffer",
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", "echasnovski/mini.bufremove" },
    keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Delete others" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        show_buffer_close_icons = true,
        show_close_icon = false,
        -- Function (not string): runs synchronously, no scheduled-race.
        close_command = function(bufnr)
          require("mini.bufremove").delete(bufnr, false)
        end,
        right_mouse_command = function(bufnr)
          require("mini.bufremove").delete(bufnr, false)
        end,
        offsets = {
          { filetype = "neo-tree", text = "Explorer", highlight = "Directory", text_align = "left" },
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = {
          -- macro-recording / search-count indicator (render-time require: safe if noice isn't loaded)
          {
            function()
              return require("noice").api.status.mode.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.mode.has()
            end,
            color = { fg = "#fabd2f" },
          },
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
}
