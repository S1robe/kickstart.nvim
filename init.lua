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
vim.opt.timeoutlen = 800 -- Key Timeout
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
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar", ".gpg"})
vim.opt.diffopt:append("linematch:60")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
vim.keymap.set("n", "<leader>E", "<cmd>Explore<CR>")

-- Marks & Harpoon Replacement
vim.keymap.set("n", "<leader>a1", "mA")
vim.keymap.set("n", "<leader>a2", "mB")
vim.keymap.set("n", "<leader>a3", "mC")
vim.keymap.set("n", "<leader>a4", "mD")
vim.keymap.set("n", "<leader>a5", "mE")
vim.keymap.set("n", "<leader>a6", "mF")
vim.keymap.set("n", "<leader>a7", "mG")
vim.keymap.set("n", "<leader>a8", "mH")
vim.keymap.set("n", "<leader>1", "g'A")
vim.keymap.set("n", "<leader>2", "g'B")
vim.keymap.set("n", "<leader>3", "g'C")
vim.keymap.set("n", "<leader>4", "g'D")
vim.keymap.set("n", "<leader>5", "g'E")
vim.keymap.set("n", "<leader>6", "g'F")
vim.keymap.set("n", "<leader>7", "g'G")
vim.keymap.set("n", "<leader>8", "g'H")

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Moving lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Arbitrary Code to Buffer
vim.keymap.set("n", "<leader>c", runcmd)
vim.keymap.set("n", "<C-s>", "cmd write<CR>")

-- Generate tags for current directory.
vim.cmd("command! MakeTags !ctags -R .")

-- vim.cmd.colorscheme("habamax")
-- vim.cmd.colorscheme("sorbe")
vim.cmd.colorscheme("lunaperche")
-- vim.cmd.colorscheme("wildcharm")
-- vim.cmd.colorscheme("zaibatsu")

require('pkgs')
