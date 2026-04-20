local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- === Lazydev =================================================================

require('lazydev').setup {
  library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } },
}

-- === Fidget ==================================================================

require('fidget').setup {}

-- === Mason ===================================================================

require('mason').setup()
require('mason-lspconfig').setup()
require('mason-tool-installer').setup {
  ensure_installed = {
    'stylua',
    'eslint',
    'biome',
    'prettierd',
    'lua-language-server',
    'gopls',
    'bash-language-server',
    'typescript-language-server',
    'html-lsp',
    'css-lsp',
    'tailwindcss-language-server',
  },
}

-- === LSP Configs =============================================================

local web_filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }

vim.lsp.config['ts_ls'] = {
  capabilities = capabilities,
  init_options = { provideFormatter = false },
}

vim.lsp.config['biome'] = {
  capabilities = capabilities,
  filetypes = web_filetypes,
}

vim.lsp.config['eslint'] = {
  capabilities = capabilities,
  filetypes = web_filetypes,
  settings = { format = false },
}

vim.lsp.config['lua_ls'] = {
  capabilities = capabilities,
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
    },
  },
}

vim.lsp.config['gopls'] = { capabilities = capabilities }
vim.lsp.config['bashls'] = { capabilities = capabilities }
vim.lsp.config['html'] = { capabilities = capabilities }
vim.lsp.config['cssls'] = { capabilities = capabilities }
vim.lsp.config['tailwindcss'] = { capabilities = capabilities }

vim.lsp.enable { 'gopls', 'bashls', 'ts_ls', 'biome', 'eslint', 'html', 'cssls', 'tailwindcss', 'lua_ls' }

-- === Diagnostics =============================================================

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {},
  virtual_text = { source = 'if_many', spacing = 4 },
}

-- === On Attach ===============================================================

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    local snacks = require 'snacks'

    map('gd', function()
      snacks.picker.lsp_definitions()
    end, '[G]oto [D]efinition')
    map('gr', function()
      snacks.picker.lsp_references()
    end, '[G]oto [R]eferences')
    map('gI', function()
      snacks.picker.lsp_implementations()
    end, '[G]oto [I]mplementation')
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('<leader>D', function()
      snacks.picker.lsp_type_definitions()
    end, 'Type [D]efinition')
    map('<leader>ds', function()
      snacks.picker.lsp_symbols()
    end, '[D]ocument [S]ymbols')
    map('<leader>ws', function()
      snacks.picker.lsp_workspace_symbols()
    end, '[W]orkspace [S]ymbols')
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    if client:supports_method 'textDocument/documentHighlight' then
      local group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = group,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(e)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = e.buf }
        end,
      })
    end

    if client:supports_method 'textDocument/inlayHint' then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- === Treesitter =============================================================
require('nvim-treesitter').install {
  'bash',
  'c',
  'css',
  'diff',
  'graphql',
  'html',
  'lua',
  'luadoc',
  'query',
  'sql',
  'vim',
  'vimdoc',
  'go',
}

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
