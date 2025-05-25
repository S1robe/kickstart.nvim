-- This is where custom keys are defined, this way theyre are complete separate from the base stuff
-- Easily configurable

-- [[ Basic Keymaps ]]
--  See `:help map()`

function mapp(mode, keys, does, tbl)
  if type(tbl) == "table" then
    vim.keymap.set(mode, keys, does, tbl or { desc = 'Custom Keybind' })
  elseif type(tbl) == "string" then
    vim.keymap.set(mode, keys, does, { desc = tbl })
  else
    vim.keymap.set(mode, keys, does, { desc = 'Custom Keybind' })
  end
end

mapp('n', '<leader>E', '<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>')

-- Set highlight on search, but clear on pressing <Esc> in normal mode
mapp('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
mapp('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
mapp('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
-- mapp('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
mapp('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- TIP: Disable arrow keys in normal mode
mapp('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
mapp('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
mapp('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
mapp('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
mapp('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
mapp('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
mapp('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
mapp('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Custom Keympas for navigation
mapp({ 'n', 'i' }, '<C-s>', vim.cmd.write, { desc = 'Write Buffer' })
mapp({ 'n', 'i' }, '<C-S>', vim.cmd.wa, { desc = 'Write all buffers' })
mapp('v', 'J', ":m '>+1<CR>gv=gv")
mapp('v', 'K', ":m '<-2<CR>gv=gv")
mapp('n', '<C-d>', '<C-d>zz')
mapp('n', '<C-u>', '<C-u>zz')

-- Special formatting things for markdown
mapp({ 'i', 'n' }, '<F13>', '# ', 'Markdown for Header 1')
mapp({ 'i', 'n' }, '<F14>', '## ', 'Markdown for Header 2')
mapp({ 'i', 'n' }, '<F15>', '### ', 'Markdown for Header 3')
mapp({ 'i', 'n' }, '<F16>', '#### ', 'Markdown for Header 4')
mapp({ 'i', 'n' }, '<F17>', '##### ', 'Markdown for Header 5')
mapp({ 'i', 'n' }, '<F18>', '###### ', 'Markdown for Header 6')

-- LSP Stuff is defined in autocommands.lua because its defined only when the lsp attaches

-- Snacks Definitions for file movement are in snacks.lua

-- Harpoon Definitions are in custom/harpoon.lua

-- Undo Tree
mapp('n', '<leader>u', vim.cmd.UndotreeToggle, "Undo Tree Toggle")
