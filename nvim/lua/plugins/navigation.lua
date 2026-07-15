return {
  { 'folke/snacks.nvim', priority = 1000, lazy = false,
    opts = { picker = {}, notifier = {}, input = {} },
    keys = {
      { '<leader>f', function() Snacks.picker.files() end },
      { '<leader>s', function() Snacks.picker.grep() end },
      { '<leader>b', function() Snacks.picker.buffers() end },
      { 'gd',        function() Snacks.picker.lsp_definitions() end },
    } },
  { 'stevearc/oil.nvim', opts = { view_options = { show_hidden = true } },
    keys = { { '<leader>e', '<cmd>Oil<cr>' } } },
}
