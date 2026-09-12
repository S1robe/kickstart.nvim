-- shiftwidth, expandab, path, mouse, signcolumn, showmatch, autoread, auto indent, undofile & dir
vim.cmd('set sw=4 et sts=-1 path+=** mouse=nv scl=yes:3 sm ar ai udf udir=$HOME/.nvim/undodir')
vim.g.netrw_keepdir = 0
vim.g.netrw_banner = 0
vim.g.netrw_localmkdir = "mkdir -p" -- change mkdir cmd
vim.g.netrw_localcopycmd = "cp -r" -- change copy command
vim.g.netrw_localrmdir = "rm -r" -- change delete command

--- Highlights
vim.cmd.filetype("plugin on")
vim.cmd.syntax("enable")

-- Scratch pad
vim.keymap.set("n", "<space>s", function()
    vim.ui.input({}, function(c)
            if c and c~="" then
                vim.cmd("noswapfile vnew")
                vim.bo.buftype = "nofile"
                vim.bo.bufhidden = "wipe"
                vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.systemlist(c))
            end
        end)
end)

-- Allow Esc to close quick fix
vim.api.nvim_create_autocmd("FileType", { pattern = "qf", callback = function() vim.keymap.set('n', '<Esc>', '<cmd>cclose<cr>', { buffer = true, silent = true, }) end, })

vim.api.nvim_create_user_command("Vimgrep", function(opts)
  local escaped = vim.fn.escape(opts.args, [[\/]])
  vim.cmd("vimgrep /" .. escaped .. "/gj " .. vim.fn.getcwd() .. "/**/*")
  vim.cmd("copen")
end, { nargs = 1 })

vim.keymap.set("n", "<space>sg", ":Vimgrep ")

vim.keymap.set({'n'}, '<space>dd', function() vim.diagnostic.setqflist({ open = true }) end)
require('colors.luna_pastel').setup() 
-- vim.cmd.colorscheme("retrobox")
-- vim.cmd.colorscheme("lunaperche")

-- window manip
vim.keymap.set('n', "<C-h>", "<C-w><")
vim.keymap.set('n', "<C-l>", "<C-w>>")
vim.keymap.set('n', "<C-j>", "<C-w>-")
vim.keymap.set('n', "<C-k>", "<C-w>+")
vim.keymap.set('n', "<C-d>", "<C-d>zz")
vim.keymap.set('n', "<C-u>", "<C-u>zz")
vim.keymap.set('n', "<space>E", ":Explore<CR>");

local lsps = {  "basedpyright", "ts_ls", "ast_grep", "arduino_language_server", "clangd", "bashls" } -- Clangd requried for arduino to work.
local ft_formatters = {
    python = {"black"},
    javascript = {"prettier"},
    typescript = {"prettier"},
    html = {'prettier'},
    css = {'prettier'},
    markdown = {'prettier'},
}
local plugins = {
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter',           name = 'nvim-treesitter' },
    { src = 'https://github.com/neovim/nvim-lspconfig',                     name = 'nvim-lspconfig', config = 'no' },
    { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim', name = 'render-markdown' },
    { src = 'https://github.com/mason-org/mason.nvim',                      name = 'mason' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim',            name = 'mason-lspconfig' , config = { ensure_installed = lsps, automatic_enable = lsps }},
    { src = 'https://github.com/stevearc/conform.nvim',                     name = 'conform',  config = { formatters_by_ft = ft_formatters, fmt_exec_path = vim.fn.stdpath("data") .. "/mason/bin", } },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons',               name = 'nvim-web-devicons' },
}


vim.pack.add(plugins)

for _, plugin in ipairs(plugins) do
    if not (plugin.config == "no") then
        _G[plugin.name] = require(plugin.name)
    end
    -- If the plugin was able to be sourced, we then run the config
    if not (_G[plugin.name] == nil) then
        _G[plugin.name].setup(plugin.config)
    end
end

vim.keymap.set({'n', 'v'}, '<space>F', function() require("conform").format({ async = true }) end)
