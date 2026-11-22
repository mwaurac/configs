-- Completion: blink.cmp (LazyVim default)
return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      -- Enter accepts the selected item (else newline). Tab/S-Tab are left
      -- at blink defaults (snippet jump), matching your muscle memory.
      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      completion = { documentation = { auto_show = true, auto_show_delay_ms = 300 } },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      signature = { enabled = true },
      -- `:` / `/` autosuggest (shows inside the noice popup).
      -- Tab/Enter left at blink cmdline defaults: Tab cycles, Enter runs.
      cmdline = {
        enabled = true,
        keymap = { preset = "cmdline" },
        -- 'path' enables filesystem completion for `:e /`, `:e ~/`, etc.
        sources = { "buffer", "cmdline", "path" },
        completion = {
          menu = { auto_show = true },
          ghost_text = { enabled = true },
          list = { selection = { preselect = true, auto_insert = true } },
        },
      },
    },
  },
}
