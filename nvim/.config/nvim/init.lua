-- === Leaders ================================================================

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false

-- === Plugins =================================================================

vim.pack.add {
  -- Editing
  'https://github.com/tpope/vim-sleuth',
  'https://github.com/mg979/vim-visual-multi',
  'https://github.com/altermo/ultimate-autopair.nvim',
  'https://github.com/windwp/nvim-ts-autotag',
  'https://github.com/echasnovski/mini.nvim',

  -- Navigation
  'https://github.com/stevearc/oil.nvim',

  -- Git
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/shumphrey/fugitive-gitlab.vim',
  'https://github.com/lewis6991/gitsigns.nvim',

  -- LSP / Formatting
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/folke/lazydev.nvim',
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },

  -- Completion
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-path',
  'https://github.com/hrsh7th/cmp-nvim-lsp-signature-help',
  'https://github.com/L3MON4D3/LuaSnip',
  'https://github.com/saadparwaiz1/cmp_luasnip',

  -- UI
  'https://github.com/rebelot/kanagawa.nvim',
  'https://github.com/echasnovski/mini.icons',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/folke/snacks.nvim',
}

-- === Options =================================================================

vim.opt.virtualedit = 'block'
vim.opt.wrap = false
vim.opt.colorcolumn = '80'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 15
vim.opt.confirm = true
vim.opt.mouse = 'a'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.inccommand = 'split'
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.list = false
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- === Keymaps =================================================================

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('x', '<C-c>', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>dd', function()
  vim.diagnostic.open_float { focus = false, scope = 'line' }
end, { desc = '[D]iagnostics: show current line' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true })
vim.keymap.set('n', '<leader>j', '<cmd>cnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>k', '<cmd>cprev<CR>', { noremap = true, silent = true })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<D-/>', ':normal gcc<CR>', { desc = 'Toggle comment line' }) -- macOS only
vim.keymap.set('v', '<D-/>', '<Esc>:normal gvgc<CR>', { desc = 'Toggle comment block' }) -- macOS only
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- === Autocommands ============================================================

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.go',
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'help',
  desc = 'Open help buffers to the right side',
  callback = function()
    vim.cmd 'wincmd L'
    vim.cmd 'vertical resize 80'
    vim.wo.winfixwidth = true
  end,
})

-- === Theme ===================================================================

vim.cmd.colorscheme 'kanagawa-dragon'

-- === Plugin Setup ============================================================

require 'custom.lsp'
require 'custom.search'
require 'custom.formatting'
require 'custom.autocompletion'

-- Oil (file explorer) ---------------------------------------------------------
require('oil').setup {
  default_file_explorer = true,
  float = { padding = 2, max_width = 0.5, max_height = 0.5, border = 'rounded' },
  view_options = { show_hidden = true },
}
vim.keymap.set('n', '-', '<cmd>Oil --float<cr>', { desc = 'Open Oil' })

-- Gitsigns --------------------------------------------------------------------
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- Vim Visual Multi ------------------------------------------------------------
vim.g.VM_default_mappings = 1
vim.g.VM_mouse_mappings = 1
vim.g.VM_show_warnings = 0

-- Which Key -------------------------------------------------------------------
require('which-key').setup {
  delay = 0,
  icons = {
    mappings = vim.g.have_nerd_font,
    keys = vim.g.have_nerd_font and {} or {
      Up = '<Up> ',
      Down = '<Down> ',
      Left = '<Left> ',
      Right = '<Right> ',
      C = '<C-...> ',
      M = '<M-...> ',
      D = '<D-...> ',
      S = '<S-...> ',
      CR = '<CR> ',
      Esc = '<Esc> ',
      Space = '<Space> ',
      Tab = '<Tab> ',
      BS = '<BS> ',
      NL = '<NL> ',
      ScrollWheelDown = '<ScrollWheelDown> ',
      ScrollWheelUp = '<ScrollWheelUp> ',
      F1 = '<F1>',
      F2 = '<F2>',
      F3 = '<F3>',
      F4 = '<F4>',
      F5 = '<F5>',
      F6 = '<F6>',
      F7 = '<F7>',
      F8 = '<F8>',
      F9 = '<F9>',
      F10 = '<F10>',
      F11 = '<F11>',
      F12 = '<F12>',
    },
  },
  spec = {
    { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
    { '<leader>d', group = '[D]ocument' }, -- <leader>dd is the diagnostic float, subkey of this group
    { '<leader>r', group = '[R]ename' },
    { '<leader>s', group = '[S]earch' },
    { '<leader>w', group = '[W]orkspace' },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
  },
}

-- Autopair --------------------------------------------------------------------
require('ultimate-autopair').setup()

-- Auto close/rename HTML tags -------------------------------------------------
require('nvim-ts-autotag').setup()

-- UI for Neovim notifications ------------------------------------------------

require('fidget').setup()

-- Todo Comments ---------------------------------------------------------------
require('todo-comments').setup { signs = false }

-- Mini ------------------------------------------------------------------------
require('mini.ai').setup { n_lines = 500 }
require('mini.surround').setup()
local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }
statusline.section_location = function()
  return '%2l:%-2v'
end

-- Render Markdown -------------------------------------------------------------
require('render-markdown').setup {
  code = { sign = false, width = 'block', right_pad = 1 },
  checkbox = { enabled = false },
}

vim.keymap.set('n', '<leader>um', function()
  local m = require 'render-markdown'
  if require('render-markdown.state').enabled then
    m.disable()
  else
    m.enable()
  end
end, { desc = 'Toggle [R]ender [M]arkdown' })
