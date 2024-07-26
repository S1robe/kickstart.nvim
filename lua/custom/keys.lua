--[[ vim.api.nvim_create_augroup('FileTypeSpecificKeymaps', { clear = true })

-- Define a function to insert or toggle bold formatting in Markdown
local function insert_bold()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col '.'

  -- Check if cursor is within bold text (markdown: **text**)
  if string.match(line:sub(col - 2, col + 2), '%*%*.*%*%*') then
    -- Toggle the bold by removing the asterisks
    vim.api.nvim_command 'normal! \b*\b*'
  else
    -- Insert bold markers around the cursor word
    vim.api.nvim_command 'normal! i**<ESC>f*a**<ESC>'
  end
end

vim.api.nvim_create_autocmd('FileType', {
  group = 'FileTypeSpecificKeymaps',
  pattern = 'markdown',
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', '<C-b>', ':lua insert_bold()<CR>', { noremap = true, silent = true })
  end,
}) ]]
