-- Treesitter — the syntax engine gcc was installed for (compiles parsers).
-- Pinned to the classic `master` branch, whose ensure_installed/highlight API
-- matches this config (the newer `main` branch uses a different setup).
return {
  { 'nvim-treesitter/nvim-treesitter', branch = 'master', build = ':TSUpdate', lazy = false,
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'lua', 'vim', 'vimdoc', 'bash', 'json', 'yaml', 'toml', 'markdown', 'markdown_inline' },
      highlight = { enable = true },
      indent = { enable = true },
    } },
}
