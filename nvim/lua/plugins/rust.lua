-- Rust Cargo.toml helpers: versions, upgrades, docs (LazyVim keymaps)
return {
  {
    "Saecki/crates.nvim",
    tag = "stable",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      completion = {
        crates = { enabled = true },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
    keys = {
      { "<leader>Cr", function() require("crates").reload() end, desc = "Reload crates" },
      { "<leader>Cv", function() require("crates").show_versions_popup() end, desc = "Show versions" },
      { "<leader>Cf", function() require("crates").show_features_popup() end, desc = "Show features" },
      { "<leader>Cd", function() require("crates").show_dependencies_popup() end, desc = "Show dependencies" },
      { "<leader>Cu", function() require("crates").update_crate() end, desc = "Update crate" },
      { "<leader>Ca", function() require("crates").update_all_crates() end, desc = "Update all crates" },
      { "<leader>CU", function() require("crates").upgrade_crate() end, desc = "Upgrade crate" },
      { "<leader>CA", function() require("crates").upgrade_all_crates() end, desc = "Upgrade all crates" },
      { "<leader>CH", function() require("crates").open_homepage() end, desc = "Open homepage" },
      { "<leader>CR", function() require("crates").open_repository() end, desc = "Open repository" },
      { "<leader>CD", function() require("crates").open_documentation() end, desc = "Open docs" },
      { "<leader>CC", function() require("crates").open_crates_io() end, desc = "Open crates.io" },
    },
  },
}
