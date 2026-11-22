-- General keymaps (plugin-specific maps live in lua/plugins/*.lua)
local map = vim.keymap.set

-- Better up/down for wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move lines up/down (LazyVim-style)
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Buffers / tabs (bufferline; close via mini.bufremove, see lua/plugins/tabs.lua)
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Delete other buffers" })
map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Delete buffers to the left" })
map("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Delete buffers to the right" })
map("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Pin buffer" })

-- Windows
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>-", "<C-W>s", { desc = "Split below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split right" })

-- File explorer
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })
map("n", "<leader>E", "<cmd>Neotree focus<cr>", { desc = "Focus file explorer" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Save / quit
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Write every modified buffer that has a real file behind it. Plain `:wa`
-- errors with E141 on scratch/unnamed buffers (e.g. a fresh `:enew`), which
-- aborts the save halfway through, so filter those out.
local function save_all()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local bt = vim.bo[buf].buftype
    if bt == "" and vim.bo[buf].modified and vim.api.nvim_buf_get_name(buf) ~= "" then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd.write()
      end)
    end
  end
end

-- <C-S-s> needs a terminal that reports shifted keys (kitty keyboard protocol:
-- ghostty, kitty, wezterm, foot - or any GUI). Under tmux this also needs
-- `extended-keys on` + `extended-keys-format csi-u` (see dotfiles/tmux/tmux.conf).
map({ "i", "x", "n", "s" }, "<C-S-s>", function()
  save_all()
  vim.cmd.stopinsert()
end, { desc = "Save all files" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Inlay hints (LSP type annotations shown inline, LazyVim-style)
map("n", "<leader>uh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
end, { desc = "Toggle inlay hints" })

-- Stay in visual mode when indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Diagnostic jumps
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Right-side persistent terminal toggle (no plugin), on Ctrl-/ only.
-- Why not <leader>wd to close? <C-W>c / :q only hides the window but
-- doesn't give you a toggle-back, and :bdelete!/:quit on last window kills
-- the shell job. This keeps one terminal buffer/job alive and just
-- shows/hides its window on the right.
local _term_buf, _term_win = nil, nil
local function toggle_term_right()
  -- Hide if our window is currently visible
  if _term_win and vim.api.nvim_win_is_valid(_term_win) then
    vim.api.nvim_win_hide(_term_win)
    _term_win = nil
    return
  end
  -- Buffer died (e.g. `exit` / :bdelete) -> drop it so we recreate below
  if _term_buf and not vim.api.nvim_buf_is_valid(_term_buf) then
    _term_buf, _term_win = nil, nil
  end
  local width = math.floor(vim.o.columns * 0.35)
  vim.cmd("botright vsplit")
  vim.cmd("vertical resize " .. width)
  _term_win = vim.api.nvim_get_current_win()
  if _term_buf and vim.api.nvim_buf_is_valid(_term_buf) then
    vim.api.nvim_win_set_buf(_term_win, _term_buf)
  else
    vim.cmd("terminal")
    _term_buf = vim.api.nvim_get_current_buf()
    -- Dead process leaves a useless buffer; auto-forget it so next
    -- toggle creates a fresh shell instead of re-showing `[Process exited]`
    vim.api.nvim_create_autocmd("TermClose", {
      buffer = _term_buf,
      once = true,
      callback = function()
        _term_buf, _term_win = nil, nil
      end,
    })
  end
  vim.wo[_term_win].number = false
  vim.wo[_term_win].relativenumber = false
  vim.wo[_term_win].signcolumn = "no"
  vim.cmd("startinsert")
end
-- Ctrl-/ toggle: terminals send it as <C-_> (0x1F), so map both notations
-- (same physical key, not two bindings). Covers normal/insert/terminal so
-- you can toggle without leaving insert.
map({ "n", "i", "t" }, "<C-/>", toggle_term_right, { desc = "Toggle terminal" })
map({ "n", "i", "t" }, "<C-_>", toggle_term_right, { desc = "Toggle terminal" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
