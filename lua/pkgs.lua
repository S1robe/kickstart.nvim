-- Load Packages
vim.pack.add({
        -- LSP
        'https://github.com/nvim-treesitter/nvim-treesitter',
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/nvim-lua/plenary.nvim',
	'https://github.com/mason-org/mason.nvim',
	'https://github.com/mason-org/mason-lspconfig.nvim',
	'https://github.com/saghen/blink.cmp',
        -- Nice to Haves
        'https://github.com/MeanderingProgrammer/render-markdown.nvim',
        'https://github.com/folke/snacks.nvim',
        'https://github.com/windwp/nvim-autopairs',
        'https://github.com/nvim-tree/nvim-web-devicons',
})
require 'lsp'
require 'util'
