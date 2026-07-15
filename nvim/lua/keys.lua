-- Esc also saves the file (spam Esc after an edit)
vim.keymap.set('n', '<Esc>', '<cmd>w<cr><Esc>')
-- Ctrl+A selects all, like every other editor
vim.keymap.set('n', '<C-a>', 'ggVG')
-- Paste over a selection without clobbering the clipboard
vim.keymap.set('x', 'p', '"_dP')
