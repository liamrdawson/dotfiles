vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResized' }, {
  desc = 'Setup LSP hover window',
  callback = function()
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.3)

    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = 'rounded',
      max_width = width,
      max_height = height,
    })
  end,
})
