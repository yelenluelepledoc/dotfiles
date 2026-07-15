return {
  { 'NeogitOrg/neogit', dependencies = { 'nvim-lua/plenary.nvim' },
    keys = { { '<leader>g', '<cmd>Neogit<cr>' } } },
  { 'lewis6991/gitsigns.nvim', event = 'BufWinEnter',
    opts = { current_line_blame = true } },
  { 'folke/which-key.nvim', event = 'VeryLazy', opts = {} },
}
