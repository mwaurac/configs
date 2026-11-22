-- Autocommands (LazyVim-comparable)
local function augroup(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("yank_highlight"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize"),
  callback = function()
    local tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. tab)
  end,
})

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = { "qf", "help", "man", "notify", "lspinfo", "checkhealth", "query" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Open directories with the sidebar explorer, not a netrw buffer.
-- `nvim .` -> dashboard in main window + neo-tree sidebar, working dir set.
-- Zero listed buffers: no [No Name] tabs, nothing in :ls.
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("open_directory"),
  callback = function()
    if vim.fn.argc() ~= 1 then
      return
    end
    local arg = vim.fn.argv(0)
    local stat = (vim.uv or vim.loop).fs_stat(arg)
    if not (stat and stat.type == "directory") then
      return
    end
    local dir = vim.fn.fnamemodify(arg, ":p")
    vim.cmd.cd(dir)
    local main_win = vim.api.nvim_get_current_win()
    local ok, neo_cmd = pcall(require, "neo-tree.command")
    if ok then
      pcall(neo_cmd.execute, { action = "focus", source = "filesystem", position = "left", dir = dir })
    else
      pcall(vim.cmd, "Neotree focus dir=" .. vim.fn.fnameescape(dir))
    end
    -- Open the start screen in the main window (alpha skips auto-start when
    -- args are given, so start it explicitly), then delete the leftover
    -- directory buffer once hidden. Result: sidebar + dashboard, zero
    -- listed buffers.
    -- NOTE: :Alpha must run BEFORE deleting the leftover: deleting a
    -- displayed buffer lets the window grab the tree buffer, which makes
    -- neo-tree close the sidebar. Replacing it explicitly is deterministic.
    if vim.api.nvim_win_is_valid(main_win) then
      local leftover = vim.api.nvim_win_get_buf(main_win)
      vim.api.nvim_set_current_win(main_win)
      if pcall(vim.cmd, "Alpha") then
        local current = vim.api.nvim_win_get_buf(main_win)
        if current ~= leftover and vim.api.nvim_buf_is_valid(leftover) then
          vim.api.nvim_buf_delete(leftover, { force = true })
        end
      else
        -- alpha unavailable: hide the leftover instead of showing [No Name]
        vim.bo[leftover].buflisted = false
        vim.bo[leftover].buftype = "nofile"
        vim.bo[leftover].bufhidden = "wipe"
        vim.bo[leftover].swapfile = false
      end
      -- land back in the tree, ready to browse
      if ok then
        pcall(neo_cmd.execute, { action = "focus", source = "filesystem", position = "left", dir = dir })
      end
    end
  end,
})

-- Wrap + spell for text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
