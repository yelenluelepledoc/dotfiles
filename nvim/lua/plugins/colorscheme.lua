-- Match the terminal: Rosé Pine Moon inside Neovim too
return {
  { 'rose-pine/neovim', name = 'rose-pine', priority = 1000, lazy = false,
    config = function()
      require('rose-pine').setup({ variant = 'moon' })
      vim.cmd.colorscheme('rose-pine-moon')
    end },
}
