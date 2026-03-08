-- LSP
-- 'https://github.com/nvim-treesitter/nvim-treesitter',
-- 'https://github.com/neovim/nvim-lspconfig',
-- 'https://github.com/mason-org/mason.nvim',
-- 'https://github.com/mason-org/mason-lspconfig.nvim',
-- 'https://github.com/saghen/blink.cmp',

-------------- Tree Sitter --------------
local treesitter_parsers = {
    'bash','c','python','javascript','markdown','asm','awk','bibtext','perl','cpp','csv','yaml','diff','disassembly','dockerfile','html','java','json','latex','lua','make','regex','rust','solidity','terraform',
}
-- Install the above parsers
local treesitter = require('nvim-treesitter')
treesitter.install { treesitter_parsers }
treesitter.update() -- Runs TSUpdate

-- Register the treesitter highlighting for every file type.
vim.api.nvim_create_autocmd('FileType', {
    pattern = { '*' },
    callback = function(args)
        local filetype = args.match
        local lang = vim.treesitter.language.get_lang(filetype)
        if vim.treesitter.language.add(lang) then
            -- do these for every filetype we support
            vim.treesitter.start() 
            -- Folding Capacity
            vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
--            vim.wo[0][0].foldmethod = 'expr'
            -- Indentation
--            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end
})
------------- End Tree Sitter -------------

---- LSP Config ----
-- Since LSP Config is handled by mason, we do not call require'nvim-lspconfig'
-- This is legacy anyway, and would be done with vim.lsp.enable('...lsp...')

-- Load Mason which downloads all the LSPs for us
require 'mason'.setup() 
-- Load the lspconfig bridge
-- This also auto enables any installed LSPs ideally paired to the languages found in treesitter_parsers above.
require 'mason-lspconfig'.setup()

---- Blink ----
-- This is a completion support from the LSPs, cmdline, function signatures and snippets
require 'blink.cmp'.setup({
    fuzzy = { implementation = 'lua' },
})
