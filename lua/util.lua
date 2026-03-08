-- Nice to Haves
-- 'https://github.com/MeanderingProgrammer/render-markdown.nvim',
-- 'https://github.com/folke/snacks.nvim',
-- 'https://github.com/windwp/nvim-autopairs',
-- 'https://github.com/nvim-tree/nvim-web-devicons',

---- Render Markdown ----
require'render-markdown'.setup({
    -- Use Completions and works with blink cmp
    completions = { lsp = { enabled = true } }
})

---- Nvim Autopairs ----
require'nvim-autopairs'.setup({})


---- Folke Snacks ----
require'snacks'.setup({
    bigfile = { enabled = true, size = 1024 * 1024 * 5 }, -- 5Mb are ignored by LSP
    input = { enabled = true },
    picker  = { 
        enabled = true,
        sources = {
            files = { 
                hidden = true,
                ignored = true,
                win = {
                    input = {
                        keys = {
                            ["<S-h>"] = "toggle_hidden",
                            ["<S-i>"] = "toggle_ignored",
                            ["<S-f>"] = "toggle_follow",
                            ["<C-y>"] = { "yazi_copy_relative_path", mode = { "n", "i" } },
                        },
                    },
                },
                exclude = {
                    "**/.git/*",
                    "**/node_modules/*",
                    "**/cache/*",
                    "**/venv",
                },
            },
            grep = { 
                hidden = true,
                ignored = true,
                win = {
                    input = {
                        keys = {
                            ["<S-h>"] = "toggle_hidden",
                            ["<S-i>"] = "toggle_ignored",
                            ["<S-f>"] = "toggle_follow",
                        },
                    },
                },
                exclude = {
                    "**/.git/*",
                    "**/node_modules/*",
                    "**/cache/*",
                    "**/venv"
                },
            },
            grep_buffer = {},
            explorer = {
                hidden = true,
                ignored = true,
                supports_live = true,
                auto_close = true,
                diagnostics = true,
                diagnostics_open = false,
                focus = "list",
                follow_file = true,
                git_status = true,
                git_status_open = true,
                git_untracked = true,
                jump = { close = true },
                tree = true,
                watch = true,
                exclude = {
                    ".git",
                    "**/venv"
                },
            },
        },
    },
    rename  = { enabled = true },
    notifier  = { enabled = true },
    quickfile  = { enabled = true },
    statuscolumn  = { enabled = true },
    words  = { enabled = true },
    util  = { enabled = true },
})

---- dev Icons ----
require'nvim-web-devicons'.setup()

--- Plugin Keymaps
local keymaps = {
        { "<leader><space>",    function() Snacks.picker.smart()                               end, desc = "Smart Find Files" },
        { "<leader><tab><tab>", function() Snacks.explorer()                                   end, desc = "File Explorer" },
        { "<leader>ff",         function() Snacks.picker.files()                               end, desc = "Find Files" },
        { "<leader>/",          function() Snacks.picker.grep()                                end, desc = "Grep" },
        { "<leader>sb",         function() Snacks.picker.lines()                               end, desc = "Buffer Lines" },
        { "<leader>sq",         function() Snacks.picker.qflist()                              end, desc = "Quickfix List" },
        { "<leader>su",         function() Snacks.picker.undo()                                end, desc = "Undo History" },
        { "<leader>sN",         function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = "Find Config File" },
        { "<leader>sd",         function() Snacks.picker.diagnostics_buffer()                  end, desc = "Buffer Diagnostics" },
        { "<leader>sD",         function() Snacks.picker.diagnostics()                         end, desc = "Diagnostics" },
        { "<leader>sH",         function() Snacks.picker.help()                                end, desc = "Help Pages" },
        { "<leader>sK",         function() Snacks.picker.keymaps()                             end, desc = "Keymaps" },
        { "<leader>sM",         function() Snacks.picker.man()                                 end, desc = "Man Pages" },
        { "<leader>s\"",         function() Snacks.picker.registers()                           end, desc = "Registers" },
        { "<leader>s:",         function() Snacks.picker.command_history()                     end, desc = "Command History" },
        { "<leader>fg",         function() Snacks.picker.git_files()                           end, desc = "Find Git Files" },
        { "<leader>fp",         function() Snacks.picker.projects()                            end, desc = "Projects" },
}
for _, map in ipairs(keymaps) do
	local opts = { desc = map.desc }
	if map.silent ~= nil then
		opts.silent = map.silent
	end
	if map.noremap ~= nil then
		opts.noremap = map.noremap
	else
		opts.noremap = true
	end
	if map.expr ~= nil then
		opts.expr = map.expr
	end

	local mode = map.mode or "n"
	vim.keymap.set(mode, map[1], map[2], opts)
end
