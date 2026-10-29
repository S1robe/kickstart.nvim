vim.cmd('set shiftwidth=4 signcolumn=yes:1 expandtab softtabstop=-1 autoindent undofile undodir=$HOME/.nvim/undodir listchars=space:·,tab:>> wildoptions=fuzzy filetype omnifunc=v:lua.vim.lsp.omnifunc notermguicolors')
vim.g.netrw_keepdir = 0

local map = function(l, r) vim.keymap.set('n', l, r) end
map("<C-d>", "<C-d>zz")         -- Keep cursor center when jumping
map("<C-u>", "<C-u>zz")
map("<space>E", ":Explore<CR>") -- Quick open files
map("<space>c", function() local c = vim.fn.input('') vim.cmd('noswapfile vnew') vim.bo.buftype, vim.bo.bufhidden = 'nofile', 'wipe' vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.systemlist(c)) end)
map("<space>g", ":sil grep! ")  -- Grep thru files
map('=', function() vim.lsp.buf.format({ async = true }) end)

-- Allow Esc to close quick fix
vim.api.nvim_create_autocmd("FileType", { pattern = "qf", callback = function() vim.keymap.set('n', '<Esc>', '<cmd>cclose<cr>', { buffer = true, silent = true, }) end, })

-- Send grep output to cwindow rather than open file
vim.api.nvim_create_autocmd('QuickFixCmdPost', { pattern = 'grep', command = 'cwindow' })

-- Clangd requried for arduino to work.
local lsps = {  "basedpyright", "ts_ls", "ast_grep", "arduino_language_server", "clangd", "bashls", 'rust_analyzer' } 
local enabled_langs = { 'cpp', 'c', 'javascript', 'typescript', 'python', 'lua', 'bash', 'rust', 'dart' } 
local plugins = {
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter',           name = 'nvim-treesitter' },
    { src = 'https://github.com/neovim/nvim-lspconfig',                     name = 'lspconfig', config = 'no'},
    { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim', name = 'render-markdown' },
    { src = 'https://github.com/mason-org/mason.nvim',                      name = 'mason' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim',            name = 'mason-lspconfig' , config = { ensure_installed = lsps, automatic_enable = lsps }},
    --{ src = "https://github.com/ggml-org/llama.vim", name = "llama", config = 'no'}
}

vim.pack.add(plugins)

for _, plugin in ipairs(plugins) do
    if not (plugin.config == "no") then _G[plugin.name] = require(plugin.name) end
    if not (_G[plugin.name] == nil) and not (_G[plugin.name].setup == nil) then _G[plugin.name].setup(plugin.config) end
end
