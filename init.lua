-------------------------------------------------------------------------------
-- Settings
-- ----------------------------------------------------------------------------

vim.opt.shiftwidth = 4 -- Treat tabs as 4 spaces
vim.opt.expandtab = true -- Expand tabs into spaces
vim.opt.softtabstop = -1 -- Treat tab stop like spaces
vim.opt.breakindent = true -- Break point indents for line wrapping

-- NetRW
vim.g.netrw_banner = 0

-- Files
vim.cmd("set path+=**") -- Set recursive into subdirs from where nvim opened
vim.opt.undodir = vim.env.HOME .. "/.nvim/undodir"
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300 -- Faster Completions
vim.opt.timeoutlen = 500 -- Key Timeout
vim.opt.ttimeoutlen = 0 -- Key Code
vim.opt.autoread = true -- reload changes outside of neovim

-- Behavior
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.inccommand = "split"
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.hlsearch = true
vim.opt.smartcase = true
vim.opt.wildmenu = true
--vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })
vim.opt.diffopt:append("linematch:60")

vim.g.mapleader = " "

-- Folds
-- vim.o.foldenable = true
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Rely on treesitter for folding
-- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()" -- Rely on treesitter for folding

-- Splits
vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.splitright = true -- Verticle splits go right

--- Graphics
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = ""
vim.opt.showmatch = true
vim.opt.scrolloff = 8
vim.opt.completeopt = "menuone,noinsert,noselect"

--- Highlights
vim.cmd.syntax("enable")
vim.cmd.filetype("plugin on")

-------------------------------------------------------------------------------
-- Functions
-- ----------------------------------------------------------------------------

local runcmd = function()
	vim.ui.input({}, function(c)
		if c and c ~= "" then
			vim.cmd("noswapfile vnew")
			vim.bo.buftype = "nofile"
			vim.bo.bufhidden = "wipe"
			vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.systemlist(c))
		end
	end)
end

-------------------------------------------------------------------------------
-- Keys
-- ----------------------------------------------------------------------------

-- Navigation
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<leader>E", "<cmd>Explore<CR>")

-- Marks & Harpoon Replacement
vim.keymap.set("n", "<leader>a1", "mA")
vim.keymap.set("n", "<leader>a2", "mB")
vim.keymap.set("n", "<leader>a3", "mC")
vim.keymap.set("n", "<leader>a4", "mD")
vim.keymap.set("n", "<leader>a5", "mE")
vim.keymap.set("n", "<leader>1", "g'A")
vim.keymap.set("n", "<leader>2", "g'B")
vim.keymap.set("n", "<leader>3", "g'C")
vim.keymap.set("n", "<leader>4", "g'D")
vim.keymap.set("n", "<leader>5", "g'E")

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Moving lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Arbitrary Code to Buffer
vim.keymap.set("n", "<leader>c", runcmd)

-- Generate tags for current directory.
vim.cmd("command! MakeTags !ctags -R .")

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { import = "plugins"} ,
})

vim.cmd.colorscheme("retrobox")
