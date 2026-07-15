-- Bootstrap lazy.nvim (clones itself on first launch; HTTPS works via schannel)
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugin specs explicitly. Each module returns a table of specs; lazy
-- flattens the nested tables. To add a plugin group, drop a new file in this
-- folder and add a require line here.
require('lazy').setup({
  spec = {
    require('plugins.navigation'),
    require('plugins.git'),
    require('plugins.colorscheme'),
    require('plugins.treesitter'),
  },
  change_detection = { notify = false },
})
