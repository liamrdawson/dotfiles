# Neovim Config

A personal Neovim configuration built on native Neovim 0.11+ features where possible, avoiding heavy plugin frameworks.

## Requirements

- Neovim 0.12+
- A terminal with true colour support
- `git`
- `ripgrep` (for grep search)
- `fd` (for file search)
- Node.js (for several LSP servers installed via Mason)

## Structure

```
~/.config/nvim/
├── init.lua
└── lua/
    └── custom/
        ├── lsp.lua            # LSP, Mason, diagnostics, lazydev, fidget
        ├── search.lua         # Snacks picker (fuzzy find, grep, buffers)
        ├── formatting.lua     # Conform (format on save)
        └── autocompletion.lua # nvim-cmp + LuaSnip
```
