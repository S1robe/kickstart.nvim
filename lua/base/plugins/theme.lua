return {
  -- Change the name of the colorscheme plugin below, and then
  -- { -- You can easily change to a different colorscheme.
  --   -- change the command in the config to whatever the name of that colorscheme is.
  --   --
  --   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  --   'Allianaab2m/penumbra.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   config = function()
  --     require('penumbra').setup {
  --       italic_comment = true,
  --       contrast = '',
  --       show_end_of_buffer = true,
  --     }
  --     -- Load the colorscheme here.
  --     -- Like many other themes, this one has different styles, and you could load
  --     vim.cmd.colorscheme 'penumbra'
  --   end,
  -- }},,
  {
    'baliestri/aura-theme',
    lazy = false,
    priority = 1000,
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. '/packages/neovim')
      vim.cmd.colorscheme 'aura-dark'
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
}
