-- Filename: luna_pastel.lua
-- High-contrast Neovim colorscheme with Treesitter support

local M = {}

M.setup = function()
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.o.background = "dark"
  vim.g.colors_name = "luna_pastel"

  local colors = {
    bg          = "#000000", -- OLED black
    fg          = "#EAEAEA", -- ash white
    grey_dark   = "#222222",
    grey_med    = "#555555",
    lavender    = "#B18CFF", -- keywords / types
    peach       = "#FFB86C", -- strings
    lime        = "#7EE787", -- success / additions
    pastel_blue = "#79C0FF", -- functions / identifiers

    error_red   = "#FF6B6B", -- errors
    warn_yellow = "#E3D26F", -- warnings

    selection   = "#3F3A5F", -- muted selection
  }
  local a = {}

  -- Default text
  vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
  vim.api.nvim_set_hl(0, "Comment", { fg = colors.grey_med, italic = true })
  vim.api.nvim_set_hl(0, "Constant", { fg = colors.pastel_blue })
  vim.api.nvim_set_hl(0, "String", { fg = colors.pastel_blue })
  vim.api.nvim_set_hl(0, "Character", { fg = colors.pastel_blue })
  vim.api.nvim_set_hl(0, "Number", { fg = colors.lime })
  vim.api.nvim_set_hl(0, "Boolean", { fg = colors.lime })
  vim.api.nvim_set_hl(0, "Identifier", { fg = colors.fg })
  vim.api.nvim_set_hl(0, "Function", { fg = colors.peach, bold = true })
  vim.api.nvim_set_hl(0, "Statement", { fg = colors.lavender, bold = true })
  vim.api.nvim_set_hl(0, "Conditional", { fg = colors.lavender, bold = true })
  vim.api.nvim_set_hl(0, "Repeat", { fg = colors.lavender, bold = true })
  vim.api.nvim_set_hl(0, "Operator", { fg = colors.lavender })
  vim.api.nvim_set_hl(0, "Keyword", { fg = colors.lavender, bold = true })
  vim.api.nvim_set_hl(0, "PreProc", { fg = colors.peach })
  vim.api.nvim_set_hl(0, "Type", { fg = colors.lime, bold = true })
  vim.api.nvim_set_hl(0, "Special", { fg = colors.peach })
  vim.api.nvim_set_hl(0, "Underlined", { fg = colors.pastel_blue, underline = true })
  vim.api.nvim_set_hl(0, "Error", { fg = colors.error_red, bg = colors.bg, bold = true })
  vim.api.nvim_set_hl(0, "WarningMsg", { fg = colors.warn_yellow, bg = colors.bg, bold = true })

  -- UI elements
  vim.api.nvim_set_hl(0, "Visual", { bg = colors.selection })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.grey_dark })
  vim.api.nvim_set_hl(0, "StatusLine", { fg = colors.fg, bg = colors.grey_dark })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = colors.grey_med, bg = colors.grey_dark })
  vim.api.nvim_set_hl(0, "VertSplit", { fg = colors.grey_med })
  vim.api.nvim_set_hl(0, "LineNr", { fg = colors.grey_med })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.lime, bold = true })
  vim.api.nvim_set_hl(0, "Pmenu", { fg = colors.fg, bg = colors.grey_dark })
  vim.api.nvim_set_hl(0, "PmenuSel", { fg = colors.bg, bg = colors.lavender })

  -- UI Netrw / directory highlight
  vim.api.nvim_set_hl(0, "Directory", { fg = colors.pastel_blue, bold = true })

  -- Netrw file / symlink colors
  vim.api.nvim_set_hl(0, "netrwClassify", { fg = colors.lavender, italic = true }) -- e.g., symlinks
  vim.api.nvim_set_hl(0, "netrwMarkFile", { fg = colors.peach, bold = true })     -- marked files
  vim.api.nvim_set_hl(0, "netrwDir", { fg = colors.pastel_blue, bold = true })    -- directories
  vim.api.nvim_set_hl(0, "netrwComment", { fg = colors.grey_med, italic = true }) -- info text

  -- Treesitter support
  vim.api.nvim_set_hl(0, "@comment", { fg = colors.grey_med })
  vim.api.nvim_set_hl(0, "@constant", { fg = colors.pastel_blue })
  vim.api.nvim_set_hl(0, "@string", { fg = colors.pastel_blue })
  vim.api.nvim_set_hl(0, "@character", { fg = colors.pastel_blue })
  vim.api.nvim_set_hl(0, "@number", { fg = colors.lime })
  vim.api.nvim_set_hl(0, "@boolean", { fg = colors.lime })
  vim.api.nvim_set_hl(0, "@variable", { fg = colors.fg })
  vim.api.nvim_set_hl(0, "@function", { fg = colors.peach, bold = true })
  vim.api.nvim_set_hl(0, "@function.call", { fg = colors.peach })
  vim.api.nvim_set_hl(0, "@function.builtin", { fg = colors.lavender })
  vim.api.nvim_set_hl(0, "@keyword", { fg = colors.lavender, bold = true })
  vim.api.nvim_set_hl(0, "@keyword.return", { fg = colors.lavender, bold = true })
  vim.api.nvim_set_hl(0, "@conditional", { fg = colors.lavender, bold = true })
  vim.api.nvim_set_hl(0, "@repeat", { fg = colors.lavender, bold = true })
  vim.api.nvim_set_hl(0, "@operator", { fg = colors.lavender })
  vim.api.nvim_set_hl(0, "@type", { fg = colors.lime, bold = true })
  vim.api.nvim_set_hl(0, "@type.builtin", { fg = colors.lime })
  vim.api.nvim_set_hl(0, "@include", { fg = colors.peach })
  vim.api.nvim_set_hl(0, "@variable.builtin", { fg = colors.fg })
  vim.api.nvim_set_hl(0, "@namespace", { fg = colors.lavender })
  vim.api.nvim_set_hl(0, "@parameter", { fg = colors.fg })
  vim.api.nvim_set_hl(0, "@property", { fg = colors.fg })
  vim.api.nvim_set_hl(0, "@punctuation", { fg = colors.fg })
  vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = colors.fg })
  vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = colors.fg })
  vim.api.nvim_set_hl(0, "@tag", { fg = colors.peach })
  vim.api.nvim_set_hl(0, "@tag.attribute", { fg = colors.lime })
  vim.api.nvim_set_hl(0, "@text", { fg = colors.fg })
  vim.api.nvim_set_hl(0, "@text.reference", { fg = colors.lavender })
  vim.api.nvim_set_hl(0, "@text.literal", { fg = colors.pastel_blue })
  vim.api.nvim_set_hl(0, "@text.todo", { fg = colors.warn_yellow, bold = true })
  vim.api.nvim_set_hl(0, "@error", { fg = colors.error_red, bold = true })
  vim.api.nvim_set_hl(0, "@warning", { fg = colors.warn_yellow, bold = true })
end

return M
