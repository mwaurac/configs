-- Side-panel file explorer (neo-tree)
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false, -- must load at startup so directory-open hijack works
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle explorer" },
      { "<leader>E", "<cmd>Neotree focus<cr>", desc = "Focus explorer" },
      { "<leader>ge", "<cmd>Neotree git_status toggle<cr>", desc = "Git explorer" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        follow_current_file = { enabled = true },
        -- Netrw hijack disabled: directory-open is owned by the VimEnter
        -- handler in lua/config/autocmds.lua (sidebar + dashboard). The
        -- built-in hijack fires debounced after startup and would steal
        -- the main window back.
        hijack_netrw_behavior = "disabled",
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        position = "left",
        width = 32,
        mappings = {
          ["<space>"] = "none", -- avoid conflict with leader
        },
      },
      default_component_configs = {
        indent = { with_expanders = true },
      },
    },
  },
}
