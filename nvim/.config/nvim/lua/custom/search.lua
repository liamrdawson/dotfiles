local snacks = require 'snacks'

snacks.setup {
  picker = {
    layout = 'telescope',
    sources = {
      files = {
        hidden = true,
        ignored = false,
        exclude = { '.git', 'node_modules', '.venv' },
      },
      grep = {
        hidden = true,
        exclude = { '.git', 'node_modules', '.venv' },
      },
    },
  },
}

local function yank_file_path()
  local filepath = vim.fn.expand '%'
  vim.fn.setreg('*', filepath)
  print('Yanked: ' .. filepath)
end

vim.keymap.set('n', '<leader>yp', yank_file_path, { desc = '[Y]ank file [P]ath' })

vim.keymap.set('n', '<leader>sb', function()
  require('oil').open_float(vim.fn.expand '%:p:h')
end, { desc = '[S]earch file [B]rowser' })

vim.keymap.set('n', '<leader>/', function()
  snacks.picker.lines()
end, { desc = '[/] Fuzzy search current buffer' })

vim.keymap.set('n', '<leader>s/', function()
  snacks.picker.grep_buffers()
end, { desc = '[S]earch [/] in open files' })

vim.keymap.set('n', '<leader>sn', function()
  snacks.picker.files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim config files' })

vim.keymap.set('n', '<leader>sh', function()
  snacks.picker.help()
end, { desc = '[S]earch [H]elp' })

vim.keymap.set('n', '<leader>sk', function()
  snacks.picker.keymaps()
end, { desc = '[S]earch [K]eymaps' })

vim.keymap.set('n', '<leader>sf', function()
  snacks.picker.files()
end, { desc = '[S]earch [F]iles' })

vim.keymap.set('n', '<leader>sc', function()
  snacks.picker.git_status()
end, { desc = '[S]earch [C]hanged files' })

vim.keymap.set('n', '<leader>ss', function()
  snacks.picker.pickers()
end, { desc = '[S]earch [S]elect picker' })

vim.keymap.set('n', '<leader>sw', function()
  snacks.picker.grep_word()
end, { desc = '[S]earch current [W]ord' })

vim.keymap.set('n', '<leader>sg', function()
  snacks.picker.grep()
end, { desc = '[S]earch by [G]rep' })

vim.keymap.set('n', '<leader>sd', function()
  snacks.picker.diagnostics()
end, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', '<leader>sr', function()
  snacks.picker.resume()
end, { desc = '[S]earch [R]esume' })

vim.keymap.set('n', '<leader>s.', function()
  snacks.picker.recent()
end, { desc = '[S]earch recent files' })

vim.keymap.set('n', '<leader><leader>', function()
  snacks.picker.buffers()
end, { desc = '[ ] Find existing buffers' })
