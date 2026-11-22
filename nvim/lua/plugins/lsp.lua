-- LSP: lua / python / rust / c-c++ via mason + nvim-lspconfig
-- blink.cmp provides capabilities.
return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = { "lua_ls", "pyright", "rust_analyzer", "clangd", "gopls" },
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
        pyright = {},
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              check = { command = "clippy" },
              -- Pin type hints on: this is what shows `ans: Vec<u8>`.
              -- (Siblings keep server defaults.)
              inlayHints = {
                typeHints = { enable = true },
              },
            },
          },
        },
        clangd = {},
        gopls = {},
      }

      for server, cfg in pairs(servers) do
        cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
        vim.lsp.config(server, cfg)
        vim.lsp.enable(server)
      end

      -- LSP keymaps on attach (LazyVim-style)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("custom_lsp_attach", { clear = true }),
        callback = function(event)
          local map = function(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
          end
          map("gd", vim.lsp.buf.definition, "Goto definition")
          map("gr", vim.lsp.buf.references, "References")
          map("gI", vim.lsp.buf.implementation, "Goto implementation")
          map("gy", vim.lsp.buf.type_definition, "Type definition")
          map("gD", vim.lsp.buf.declaration, "Goto declaration")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>cr", vim.lsp.buf.rename, "Rename")
          map("<leader>cD", vim.lsp.buf.type_definition, "Type definition")
          map("<leader>cf", function()
            vim.lsp.buf.format({ async = true })
          end, "Format")

          -- Inline type hints (e.g. rust-analyzer showing `ans: [u8]`)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
          end
        end,
      })

      vim.diagnostic.config({
        virtual_text = { spacing = 4, prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
      })
    end,
  },
}
