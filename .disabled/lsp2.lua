return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      -- LSP servers and clients are able to communicate to each other what features they support.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Helper function to check for local configs
      local function get_local_config(config_name)
        local config_path = vim.fn.getcwd() .. '/' .. config_name
        if vim.fn.filereadable(config_path) == 1 then
          return config_path
        end
        return nil
      end

      -- Get Vue language server path for ts_ls plugin (Mason v2)
      local vue_language_server_path = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'

      -- LSP Server Configurations grouped by language
      local servers = {
        -- ╭─────────────────────────────────────────────────────────╮
        -- │ JavaScript/TypeScript/Web Development                   │
        -- ╰─────────────────────────────────────────────────────────╯
        ts_ls = { -- TypeScript/JavaScript with Vue support via plugin
          init_options = {
            plugins = {
              {
                name = '@vue/typescript-plugin',
                location = vue_language_server_path,
                languages = { 'vue' },
              },
            },
          },
          filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
          settings = {
            typescript = {
              tsdk = './node_modules/typescript/lib',
              enablePromptUseWorkspaceTsdk = true,
              preferences = {
                importModuleSpecifier = 'non-relative',
                includePackageJsonAutoImports = 'on',
              },
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
            javascript = {
              preferences = {
                importModuleSpecifier = 'non-relative',
              },
            },
          },
          root_dir = function(fname)
            local util = require 'lspconfig.util'
            return util.root_pattern('nuxt.config.ts', 'nuxt.config.js')(fname)
              or util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json')(fname)
              or util.find_git_ancestor(fname)
          end,
        },

        vue_ls = {}, -- Still setup but in hybrid mode (default) for Vue-specific features

        html = {
          filetypes = { 'html', 'templ' },
          settings = {},
        },

        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = 'ignore',
              },
            },
            scss = {
              validate = true,
              lint = {
                unknownAtRules = 'ignore',
              },
            },
            less = {
              validate = true,
              lint = {
                unknownAtRules = 'ignore',
              },
            },
          },
        },

        tailwindcss = {
          filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  { 'class\\s*[:=]\\s*["\']([^"\']*)["\']', 1 },
                  { 'className\\s*[:=]\\s*["\']([^"\']*)["\']', 1 },
                  { 'tw\\s*`([^`]*)`', 1 },
                  { 'tw\\s*=\\s*{\\s*["\']([^"\']*)["\']', 1 },
                },
              },
            },
          },
        },

        -- ╭─────────────────────────────────────────────────────────╮
        -- │ Python                                                  │
        -- ╰─────────────────────────────────────────────────────────╯
        basedpyright = { -- Best: Type checking + completion
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = 'standard',
                autoImportCompletions = true,
                diagnosticSeverityOverrides = {
                  reportUnusedImport = 'warning',
                  reportUnusedVariable = 'warning',
                },
              },
            },
            python = {
              pythonPath = get_local_config '.venv/bin/python' or 'python',
            },
          },
        },

        -- ╭─────────────────────────────────────────────────────────╮
        -- │ Go                                                      │
        -- ╰─────────────────────────────────────────────────────────╯
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
              semanticTokens = true,
            },
          },
        },

        -- ╭─────────────────────────────────────────────────────────╮
        -- │ Java/Kotlin/JVM Languages                               │
        -- ╰─────────────────────────────────────────────────────────╯
        jdtls = {
          cmd = { 'jdtls' },
          settings = {
            java = {
              configuration = {
                runtimes = {
                  {
                    name = 'JavaSE-17',
                    path = '/usr/lib/jvm/java-17-openjdk',
                  },
                },
              },
            },
          },
        },

        kotlin_language_server = {
          settings = {
            kotlin = {
              compiler = {
                jvm = {
                  target = '17',
                },
              },
            },
          },
        },

        groovyls = {
          cmd = { 'java', '-jar', vim.fn.expand '~/.local/share/nvim/mason/packages/groovy-language-server/groovy-language-server-all.jar' },
          filetypes = { 'groovy' },
          root_dir = function(fname)
            return require('lspconfig').util.find_git_ancestor(fname)
          end,
        },

        gradle_ls = {},

        -- ╭─────────────────────────────────────────────────────────╮
        -- │ C/C++/Rust/Systems Programming                          │
        -- ╰─────────────────────────────────────────────────────────╯
        clangd = {
          cmd = {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--header-insertion=iwyu',
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=llvm',
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },

        rust_analyzer = {
          settings = {
            ['rust-analyzer'] = {
              imports = {
                granularity = {
                  group = 'module',
                },
                prefix = 'self',
              },
              cargo = {
                buildScripts = {
                  enable = true,
                },
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },

        asm_lsp = {
          filetypes = { 'asm', 's', 'S' },
        },

        -- ╭─────────────────────────────────────────────────────────╮
        -- │ Shell/Bash Scripting                                    │
        -- ╰─────────────────────────────────────────────────────────╯
        bashls = {
          filetypes = { 'sh', 'bash', 'zsh' },
        },

        -- ╭─────────────────────────────────────────────────────────╮
        -- │ Lua                                                     │
        -- ╰─────────────────────────────────────────────────────────╯
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  '${3rd}/luv/library',
                  '${3rd}/busted/library',
                },
              },
              completion = {
                callSnippet = 'Replace',
              },
              telemetry = { enable = false },
              diagnostics = {
                globals = { 'vim' },
              },
            },
          },
        },

        -- ╭─────────────────────────────────────────────────────────╮
        -- │ Functional Languages (Haskell, OCaml)                   │
        -- ╰─────────────────────────────────────────────────────────╯
        -- hls = {
        --   filetypes = { 'haskell', 'lhaskell', 'cabal' },
        -- },
        --
        -- ocamllsp = {
        --   cmd = { 'ocamllsp' },
        --   filetypes = { 'ocaml', 'ocaml.menhir', 'ocaml.interface', 'ocaml.ocamllex', 'reason', 'dune' },
        --   root_dir = require('lspconfig').util.root_pattern('*.opam', 'esy.json', 'package.json', '.ocamlformat'),
        -- },

        -- ╭─────────────────────────────────────────────────────────╮
        -- │ Dart/Flutter                                            │
        -- ╰─────────────────────────────────────────────────────────╯
        -- dartls = {
        --   cmd = { 'dart', 'language-server', '--protocol=lsp' },
        -- },

        -- ╭─────────────────────────────────────────────────────────╮
        -- │ Infrastructure/DevOps (Docker, CI/CD)                   │
        -- ╰─────────────────────────────────────────────────────────╯
        dockerls = {
          settings = {
            docker = {
              languageserver = {
                formatter = {
                  ignoreMultilineInstructions = true,
                },
              },
            },
          },
        },

        docker_compose_language_service = {},

        gh_actions_ls = {},

        -- ╭─────────────────────────────────────────────────────────╮
        -- │ Data/Configuration Languages (JSON, YAML, SQL)          │
        -- ╰─────────────────────────────────────────────────────────╯
        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },

        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = '',
              },
              schemas = require('schemastore').yaml.schemas(),
            },
          },
        },

        sqls = { -- Better than sqlls - more features and actively maintained
          cmd = { 'sqls' },
          filetypes = { 'sql', 'mysql', 'postgresql' },
          root_dir = function()
            return vim.fn.getcwd()
          end,
          settings = {
            sqls = {
              connections = {
                -- Configure your database connections here
              },
            },
          },
        },

        -- ╭─────────────────────────────────────────────────────────╮
        -- │ Document/Markup Languages (Markdown, LaTeX)             │
        -- ╰─────────────────────────────────────────────────────────╯
        marksman = {},

        texlab = {
          settings = {
            texlab = {
              auxDirectory = '.',
              bibtexFormatter = 'texlab',
              build = {
                executable = 'latexmk',
                args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
                onSave = false,
                forwardSearchAfter = false,
              },
              chktex = {
                onOpenAndSave = false,
                onEdit = false,
              },
              diagnosticsDelay = 300,
              latexFormatter = 'latexindent',
              latexindent = {
                localSearchOnly = false,
                modifyLineBreaks = false,
              },
            },
          },
        },

        -- ╭─────────────────────────────────────────────────────────╮
        -- │ Grammar/Spell Checking                                  │
        -- ╰─────────────────────────────────────────────────────────╯
        harper_ls = {
          settings = {
            ['harper-ls'] = {
              linters = {
                spell_check = true,
                spelled_numbers = false,
                an_a = true,
                sentence_capitalization = true,
                unclosed_quotes = true,
                wrong_quotes = false,
                long_sentences = true,
                repeated_words = true,
                spaces = true,
                matcher = true,
              },
            },
          },
        },

        ltex = { -- For grammar checking (ltex-ls-plus is not in Mason yet)
          filetypes = { 'markdown', 'tex', 'plaintex', 'rst' },
          settings = {
            ltex = {
              language = 'en-US',
            },
          },
        },

        typos_lsp = {
          init_options = {
            config = '~/.config/typos/typos.toml',
          },
        },
      }

      -- Ensure the servers and tools above are installed
      require('mason').setup()

      -- Complete list of tools to ensure are installed
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- LSP's
        'ts_ls',
        'vue_ls',
        'html',
        'cssls',
        'tailwindcss',
        'basedpyright',

        -- Formatters (Best & Fastest)
        'fixjson',
        'mdformat',
        'prettierd', -- Fastest for JS/TS/Web
        'ruff', -- Python formatter & linter (fastest)
        'shfmt',
        'stylua',

        -- Linters (Best & Fastest)
        'checkstyle',
        'eslint_d', -- Fastest for JS/TS

        -- Additional tools
        'ast-grep',
        'tree-sitter-cli',
        'semgrep',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable format on save for specific filetypes if needed
        local disable_filetypes = { c = false, cpp = false }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        -- JavaScript/TypeScript/Web (prettierd is fastest)
        javascript = { 'prettierd', 'eslint_d' },
        javascriptreact = { 'prettierd', 'eslint_d' },
        typescript = { 'prettierd', 'eslint_d' },
        typescriptreact = { 'prettierd', 'eslint_d' },
        vue = { 'prettierd', 'eslint_d' },
        html = { 'prettierd' },
        css = { 'prettierd', 'rustywind' },
        scss = { 'prettierd' },
        less = { 'prettierd' },
        json = { 'prettierd', 'fixjson' },
        jsonc = { 'prettierd' },
        yaml = { 'prettierd' },
        graphql = { 'prettierd' },

        -- Python (ruff is fastest)
        python = { 'ruff_format', 'ruff_organize_imports' },

        -- Go
        go = { 'goimports', 'gofumpt' },
        gomod = { 'goimports' },
        gowork = { 'goimports' },

        -- Rust
        rust = { 'rustfmt' },

        -- Java/Kotlin
        java = { 'google-java-format' },
        kotlin = { 'ktfmt' },
        groovy = { 'npm-groovy-lint' },

        -- C/C++
        c = { 'clang-format' },
        cpp = { 'clang-format' },

        -- Shell
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },

        -- Lua
        lua = { 'stylua' },

        -- SQL
        sql = { 'pgformatter', 'sql-formatter' },
        mysql = { 'sql-formatter' },
        postgresql = { 'pgformatter' },

        -- Document/Markup
        markdown = { 'prettierd', 'mdformat' },
        ['markdown.mdx'] = { 'prettierd' },
        tex = { 'latexindent' },
        plaintex = { 'latexindent' },

        -- Functional Languages
        ocaml = { 'ocamlformat' },
        haskell = { 'fourmolu' },

        -- Other
        asm = { 'asmfmt' },
        dockerfile = { 'dockerfile' },
        toml = { 'taplo' },
        dart = { 'dart_format' },
      },
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    lazy = false,
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        build = 'make install_jsregexp',
        dependencies = {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
            -- Load custom snippets
            require('luasnip.loaders.from_vscode').lazy_load { paths = { './snippets' } }
          end,
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lua',
      'onsails/lspkind.nvim', -- VSCode-like pictograms
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local lspkind = require 'lspkind'

      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'luasnip' },
          { name = 'nvim_lua' },
          { name = 'path' },
          { name = 'buffer', keyword_length = 3 },
        },
        formatting = {
          format = lspkind.cmp_format {
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...',
            before = function(entry, vim_item)
              vim_item.menu = ({
                nvim_lsp = '[LSP]',
                luasnip = '[Snippet]',
                buffer = '[Buffer]',
                path = '[Path]',
                nvim_lua = '[Lua]',
              })[entry.source.name]
              return vim_item
            end,
          },
        },
      }

      -- `/` cmdline setup.
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
      })

      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          { name = 'cmdline' },
        }),
      })
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'cpp',
        'css',
        'dart',
        'diff',
        'dockerfile',
        'go',
        'gomod',
        'gosum',
        'gowork',
        'graphql',
        'groovy',
        'haskell',
        'html',
        'java',
        'javascript',
        'jsdoc',
        'json',
        'jsonc',
        'kotlin',
        'latex',
        'lua',
        'luadoc',
        'luap',
        'markdown',
        'markdown_inline',
        'ocaml',
        'python',
        'query',
        'regex',
        'rust',
        'scss',
        'sql',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'vue',
        'yaml',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
    },
    config = function(_, opts)
      -- Prefer git instead of curl in order to improve connectivity in some environments
      require('nvim-treesitter.install').prefer_git = true
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      lint.linters_by_ft = {
        -- JavaScript/TypeScript/Web
        javascript = { 'eslint_d' }, -- oxlint for extra fast checks
        javascriptreact = { 'eslint_d' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        vue = { 'eslint_d' },
        html = { 'htmlhint' },
        css = { 'stylelint' },
        scss = { 'stylelint' },
        less = { 'stylelint' },

        -- Python
        python = { 'ruff', 'mypy' }, -- ruff is fastest

        -- Go
        go = { 'golangcilint' },

        -- Rust
        rust = { 'clippy' },

        -- C/C++
        c = { 'cpplint' },
        cpp = { 'cpplint' },

        -- Java/Kotlin/JVM
        java = { 'checkstyle' },
        kotlin = { 'ktlint' },
        groovy = { 'npm-groovy-lint' },

        -- Shell
        sh = { 'shellcheck' },
        bash = { 'shellcheck' },
        zsh = { 'shellcheck' },

        -- Data/Config
        json = { 'jsonlint' },
        yaml = { 'yamllint' },
        dockerfile = { 'hadolint' },
        dotenv = { 'dotenv-linter' },

        -- Document/Markup
        markdown = { 'markdownlint', 'write-good' },
        tex = { 'chktex' },

        -- SQL
        sql = { 'sqlfluff' },

        -- Git
        gitcommit = { 'gitlint' },
      }

      -- Additional linters for all files
      lint.linters_by_ft['*'] = { 'typos', 'misspell' }

      -- Custom settings for textlint
      lint.linters.textlint = {
        cmd = 'textlint',
        stdin = true,
        args = { '--format', 'json', '--stdin', '--stdin-filename', '%filepath' },
        stream = 'stdout',
        ignore_exitcode = true,
        parser = require('lint.parser').from_pattern([[(%d+):(%d+)-%d+:%d+%s+(%w+)%s+(.+)]], { 'lnum', 'col', 'severity', 'message' }),
      }

      -- Add textlint to markdown files
      table.insert(lint.linters_by_ft.markdown, 'textlint')

      -- Create autocommand which carries out the actual linting
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },

  -- Additional plugins for better language support
  { 'b0o/schemastore.nvim' }, -- JSON/YAML schemas
  { 'folke/trouble.nvim', opts = {} }, -- Better diagnostics
  { 'nvim-treesitter/nvim-treesitter-textobjects' }, -- Enhanced text objects
  { 'windwp/nvim-autopairs', opts = {} }, -- Auto pairs
}
