-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.conceallevel = 0 -- Hide * markup for bold and italic, but not markers with substitutions
opt.scrolloff = 8 -- Lines of contex
opt.sidescrolloff = 8 -- Columns of context
opt.shiftwidth = 2 -- Size of an indent
opt.tabstop = 2 -- Number of spaces tabs count for
opt.expandtab = true -- Use spaces instead of tabs
