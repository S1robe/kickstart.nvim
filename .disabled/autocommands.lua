-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- This has the mapp function
require 'custom.keys'

-- Groups
local latexLoad = vim.api.nvim_create_augroup('LatexPlugins', { clear = true })
local lspLoad = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Load vimtex for tex files and .bib files
vim.api.nvim_create_autocmd('FileType', {
  group = latexLoad,
  pattern = { 'tex' },
  callback = function()
    require('lazy').load { plugins = { 'vimtex' } }
  end,
})

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = lspLoad,
  callback = function(event)
    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself.

    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    mapp('n', 'gd', require('snacks.picker').lsp_definitions, '[G]oto [D]efinition')

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    mapp('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- Find references for the word under your cursor.
    mapp('n', 'gr', require('snacks.picker').lsp_references, '[G]oto [R]eferences')

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    mapp('n', 'gI', require('snacks.picker').lsp_implementations, '[G]oto [I]mplementation')

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    mapp('n', '<leader>D', require('snacks.picker').lsp_type_definitions, 'Type [D]efinition')

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    mapp('n', '<leader>ds', require('snacks.picker').lsp_symbols, '[D]ocument [S]ymbols')

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    mapp('n', '<leader>ws', require('snacks.picker').lsp_workspace_symbols, '[W]orkspace [S]ymbols')

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    mapp('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    mapp('n', '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    -- Opens a popup that displays documentation about the word under your cursor
    --  See `:help K` for why this keymapp.
    mapp('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')

    mapp('n', '<leader>e', "<cmd>lua vim.diagnostic.open_float(0, {scope='line'})<CR>")

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- The following autocommand is used to enable inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      mapp('n', '<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})
