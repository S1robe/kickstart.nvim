-- shiftwidth, expandab, path, mouse, signcolumn, showmatch, autoread, auto indent, undofile & dir
vim.cmd('set sw=4 et sts=-1 path+=** mouse=nv scl=yes:3 sm ar ai udf udir=$HOME/.nvim/undodir')

-- no banner for file explorer
vim.g.netrw_banner = 0

--- Highlights
vim.cmd.filetype("plugin on")
vim.cmd.syntax("enable")
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
vim.keymap.set('n', "<C-h>", "<C-w><")
vim.keymap.set('n', "<C-l>", "<C-w>>")
vim.keymap.set('n', "<C-j>", "<C-w>-")
vim.keymap.set('n', "<C-k>", "<C-w>+")

-- vim.cmd.colorscheme("habamax")
-- vim.cmd.colorscheme("sorbe")
vim.cmd.colorscheme("lunaperche")
-- vim.cmd.colorscheme("wildcharm")
-- vim.cmd.colorscheme("zaibatsu")
