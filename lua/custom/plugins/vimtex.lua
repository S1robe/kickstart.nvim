-- This is only loaded when tex files are opened

return {
  'lervag/vimtex',
  lazy = true,
  init = function()
    vim.g.vimtex_view_method = 'zathura'
  end,
}
