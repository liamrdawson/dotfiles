require('conform').setup {
  formatters = {
    biome = { require_cwd = true },
    prettierd = { require_cwd = true },
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    go = { 'gofmt' },
    javascript = { 'biome', 'prettierd', stop_after_first = true },
    javascriptreact = { 'biome', 'prettierd', stop_after_first = true },
    typescript = { 'biome', 'prettierd', stop_after_first = true },
    typescriptreact = { 'biome', 'prettierd', stop_after_first = true },
    html = { 'biome', 'prettierd', stop_after_first = true },
    css = { 'biome', 'prettierd', stop_after_first = true },
    json = { 'biome', 'prettierd', stop_after_first = true },
    yaml = { 'biome', 'prettierd', stop_after_first = true },
  },
}

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format { bufnr = args.buf, timeout_ms = 500 }
  end,
})

vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
  require('conform').format { bufnr = vim.api.nvim_get_current_buf() }
end, { desc = '[F]ormat buffer' })
