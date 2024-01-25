-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function mergeOpts(opts1, opts2)
  local mergedOpts = {}

  -- Merge opts1 into mergedOpts
  for key, value in pairs(opts1 or {}) do
    mergedOpts[key] = value
  end

  -- Merge opts2 into mergedOpts
  for key, value in pairs(opts2 or {}) do
    mergedOpts[key] = value
  end

  return mergedOpts
end

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Increment / Decrement
keymap.set("n", "+", "<C-a>", { desc = "Increment value" })
keymap.set("n", "-", "<C-x>", { desc = "Decrement value" })

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d', { desc = "[D]elete a [W]ord backwards" })

-- Selcet All
keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select [A]ll" })

-- New tab
keymap.set("n", "te", ":tabedit", { desc = ":[t]ab[e]dit" })
keymap.set("n", "<tab>", ":tabnext<Return>", mergeOpts(opts, { desc = "Next Tab" }))
keymap.set("n", "<s-tab>", ":tabprev<Return>", mergeOpts(opts, { desc = "Previous Tab" }))
-- Split window
keymap.set("n", "ss", ":split<Return>", mergeOpts(opts, { desc = "Split window" }))
keymap.set("n", "sv", ":vsplit<Return>", mergeOpts(opts, { desc = "Vertical Split window" }))
-- Move window
keymap.set("n", "sh", "<C-w>h", { desc = "Go to left window" })
keymap.set("n", "sk", "<C-w>k", { desc = "Go to left window" })
keymap.set("n", "sj", "<C-w>j", { desc = "Go to left window" })
keymap.set("n", "sl", "<C-w>l", { desc = "Go to left window" })

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><", { desc = "Resize to left" })
keymap.set("n", "<C-w><right>", "<C-w>>", { desc = "Resize to right" })
keymap.set("n", "<C-w><up>", "<C-w>+", { desc = "Resize up" })
keymap.set("n", "<C-w><down>", "<C-w>-", { desc = "Resize down" })

-- Leave Insert Mode with either bracket
keymap.set("i", "<C-]>", "<C-[>", { desc = "Leave insert mode" })
