-- Bootstrap lazy.nvim (clones itself on first launch; HTTPS works via schannel)
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Auto-load every plugin spec under lua/plugins/
require('lazy').setup({
  spec = { { import = 'plugins' } },
  change_detection = { notify = false },
})
