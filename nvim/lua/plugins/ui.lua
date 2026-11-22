-- UI polish: dashboard, indent guides, icons
return {
  {
    "goolord/alpha-nvim",
    -- load at startup (no `event`): setup() registers its own VimEnter
    -- autocmd, which would never fire if loaded lazily on VimEnter.
    -- Always loaded (no argc check): the dashboard also serves as the empty
    -- main window for `nvim <dir>`, started explicitly by the handler in
    -- lua/config/autocmds.lua. Alpha's own auto-start still skips when
    -- files/dirs are passed, so `nvim <file>` is unaffected.
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
      }
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", "<cmd>Telescope find_files<cr>"),
        dashboard.button("n", "  New file", "<cmd>ene <bar> startinsert<cr>"),
        dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<cr>"),
        dashboard.button("g", "  Find text", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("c", "  Config", "<cmd>Telescope find_files cwd=~/dotfiles/nvim<cr>"),
        dashboard.button("s", "  Restore session", "<cmd>lua require('persistence').load()<cr>"),
        dashboard.button("e", "  Explorer", "<cmd>Neotree toggle<cr>"),
        dashboard.button("l", "  Lazy", "<cmd>Lazy<cr>"),
        dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
      }
      dashboard.section.footer.val = ""
      dashboard.section.footer.opts.hl = "AlphaFooter"

      -- Recent-files (MRU) section is added on VimEnter in config(),
      -- since shada/oldfiles is only available later in startup.
      local layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
      }
      table.insert(layout, { type = "padding", val = 1 })
      table.insert(layout, dashboard.section.footer)
      dashboard.config.layout = layout

      return dashboard.config
    end,
    config = function(_, opts)
      require("alpha").setup(opts)
      -- MRU + footer are filled in once startup details are known: shada /
      -- oldfiles only exists by VimEnter, final lazy.nvim stats by VeryLazy.
      local function redraw()
        pcall(vim.cmd.AlphaRedraw)
      end
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
          local dashboard = require("alpha.themes.dashboard")
          local mru_items = {
            {
              type = "text",
              val = "Recent files",
              opts = { hl = "SpecialComment", position = "center" },
            },
          }
          local seen, count = {}, 0
          for _, f in ipairs(vim.v.oldfiles or {}) do
            if count >= 8 then
              break
            end
            local path = vim.fn.fnamemodify(f, ":p")
            if vim.fn.filereadable(path) == 1 and not seen[path] then
              seen[path] = true
              local short = vim.fn.fnamemodify(path, ":~")
              if #short > 52 then
                short = vim.fn.nr2char(0x2026) .. short:sub(-51)
              end
              table.insert(
                mru_items,
                dashboard.button(tostring(count), "  " .. short, "<cmd>edit " .. vim.fn.fnameescape(path) .. "<cr>")
              )
              count = count + 1
            end
          end
          if count > 0 then
            local layout = dashboard.config.layout
            table.insert(layout, #layout, { type = "padding", val = 1 })
            table.insert(layout, #layout, { type = "group", val = mru_items, opts = { spacing = 1 } })
          end
          redraw()
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          local ok, lazy = pcall(require, "lazy")
          if not ok then
            return
          end
          local stats = lazy.stats()
          local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
          require("alpha.themes.dashboard").section.footer.val = vim.fn.nr2char(0x26A1)
            .. " Neovim loaded "
            .. stats.loaded
            .. "/"
            .. stats.count
            .. " plugins in "
            .. ms
            .. "ms"
          redraw()
        end,
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {},
  },
}
