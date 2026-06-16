-- shiftwidth, expandab, path, mouse, signcolumn, showmatch, autoread, auto indent, undofile & dir
vim.cmd('set sw=4 et sts=-1 path+=** mouse=nv scl=yes:3 sm ar ai udf udir=$HOME/.nvim/undodir')
vim.g.netrw_keepdir = 0

--- Highlights
vim.cmd.filetype("plugin on")
vim.cmd.syntax("enable")
-- Scratch pad
vim.keymap.set("n", "<space>c", function()
    vim.ui.input({}, function(c)
            if c and c~="" then
                vim.cmd("noswapfile vnew")
                vim.bo.buftype = "nofile"
                vim.bo.bufhidden = "wipe"
                vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.systemlist(c))
            end
        end)
end)

-- window manip
vim.keymap.set('n', "<C-h>", "<C-w><")
vim.keymap.set('n', "<C-l>", "<C-w>>")
vim.keymap.set('n', "<C-j>", "<C-w>-")
vim.keymap.set('n', "<C-k>", "<C-w>+")

-- Tabs 
vim.keymap.set('n', '<space>t', ':tabnew<CR>')

-- vim.cmd.colorscheme("retrobox")
--vim.cmd.colorscheme("lunaperche")
require('colors.luna_pastel').setup()

vim.pack.add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/MeanderingProgrammer/render-markdown.nvim',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/stevearc/conform.nvim',
})

-- Plugins
vim.lsp.codelens.enable(true)
require('nvim-treesitter').setup()
require('mason').setup()
local mason_lspconfig = require('mason-lspconfig')
local conform = require("conform")

local lsps = {  "basedpyright", "ts_ls", "ast_grep", "arduino_language_server", "clangd", "bashls" } -- Clangd requried for arduino to work.
local ft_formatters = {
    python = {"black"},
    javascript = {"prettier"},
    typescript = {"prettier"},
    html = {'prettier'},
    css = {'prettier'},
    markdown = {'prettier'},
}

mason_lspconfig.setup({ ensure_installed = lsps, automatic_enable = lsps })

conform.setup({
    formatters_by_ft = ft_formatters,
    fmt_exec_path = vim.fn.stdpath("data") .. "/mason/bin",
})

vim.keymap.set({'n', 'v'}, '<space>F', function() require("conform").format({ async = true }) end)
vim.keymap.set({'n'}, '<space>dd', function() vim.diagnostic.setqflist({ open = true }) end)
