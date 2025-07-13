-- LSP.lua the lsp manager

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- Automatically install LSPs and related tools to stdpath for Neovim
			-- Mason must be loaded before its dependents so we need to set it up here.
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Completions
			-- Allows extra capabilities provided by blink.cmp
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc or "" })
					end

					-- Rename the variable under your cursor.
					--  Most Language Servers support renaming across files, etc.
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("<leader>ca", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					map("gd", require("snacks.picker").lsp_definitions, "Go Definition")

					map("gr", require("snacks.picker").lsp_references, "Go References")

					map("K", vim.lsp.buf.hover, "Hover Docs")

					map(
						"<leader>e",
						"<cmd>lua vim.diagnostic.open_float(0, {scope='line'})<CR>",
						"Errors of current line"
					)
					-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			-- LSP Configuration

			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local ensure_installed = vim.tbl_keys(servers or {})

			-- Helper function to check for local configs
			local function get_local_config(config_name)
				local config_path = vim.fn.getcwd() .. "/" .. config_name
				if vim.fn.filereadable(config_path) == 1 then
					return config_path
				end
				return nil
			end

			-- Get Vue language server path for ts_ls plugin (Mason v2)
			local vue_language_server_path = vim.fn.stdpath("data")
				.. "/mason/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin/"

			-- LSP Server Configurations grouped by language
			local servers = {
				-- ╭─────────────────────────────────────────────────────────╮
				-- │ JavaScript/TypeScript/Web Development                   │
				-- ╰─────────────────────────────────────────────────────────╯
				ts_ls = { -- TypeScript/JavaScript with Vue support via plugin
					init_options = {
						plugins = {
							{
								name = "@vue/typescript-plugin",
								location = vue_language_server_path,
								languages = { "vue" },
							},
						},
					},
					filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
					settings = {
						typescript = {
							tsdk = "./node_modules/typescript/lib",
							enablePromptUseWorkspaceTsdk = true,
							preferences = {
								importModuleSpecifier = "non-relative",
								includePackageJsonAutoImports = "on",
							},
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
							},
						},
						javascript = {
							preferences = {
								importModuleSpecifier = "non-relative",
							},
						},
					},
					root_dir = function(fname)
						local util = require("lspconfig.util")
						return util.root_pattern("nuxt.config.ts", "nuxt.config.js")(fname)
							or util.root_pattern("tsconfig.json", "jsconfig.json", "package.json")(fname)
							or util.find_git_ancestor(fname)
					end,
				},

				vue_ls = {
					filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
				}, -- Still setup but in hybrid mode (default) for Vue-specific features

				html = {
					filetypes = { "html", "templ" },
					settings = {},
				},

				cssls = {
					settings = {
						css = {
							validate = true,
							lint = {
								unknownAtRules = "ignore",
							},
						},
						scss = {
							validate = true,
							lint = {
								unknownAtRules = "ignore",
							},
						},
						less = {
							validate = true,
							lint = {
								unknownAtRules = "ignore",
							},
						},
					},
				},

				tailwindcss = {
					filetypes = {
						"html",
						"css",
						"scss",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"vue",
					},
					settings = {
						tailwindCSS = {
							experimental = {
								classRegex = {
									{ "class\\s*[:=]\\s*[\"']([^\"']*)[\"']", 1 },
									{ "className\\s*[:=]\\s*[\"']([^\"']*)[\"']", 1 },
									{ "tw\\s*`([^`]*)`", 1 },
									{ "tw\\s*=\\s*{\\s*[\"']([^\"']*)[\"']", 1 },
								},
							},
						},
					},
				},

				-- ╭─────────────────────────────────────────────────────────╮
				-- │ Python                                                  │
				-- ╰─────────────────────────────────────────────────────────╯
				basedpyright = { -- Best: Type checking + completion
					filetypes = { "python", "py" },
					settings = {
						basedpyright = {
							analysis = {
								typeCheckingMode = "standard",
								autoImportCompletions = true,
								diagnosticSeverityOverrides = {
									reportUnusedImport = "warning",
									reportUnusedVariable = "warning",
								},
							},
						},
						python = {
							pythonPath = get_local_config(".venv/bin/python") or "python",
						},
					},
				},

				-- ╭─────────────────────────────────────────────────────────╮
				-- │ Shell/Bash Scripting                                    │
				-- ╰─────────────────────────────────────────────────────────╯
				bashls = {
					filetypes = { "sh", "bash", "zsh" },
				},

				-- ╭─────────────────────────────────────────────────────────╮
				-- │ Lua                                                     │
				-- ╰─────────────────────────────────────────────────────────╯
				lua_ls = {
					filetypes = { "lua" },
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME,
									"${3rd}/luv/library",
									"${3rd}/busted/library",
								},
							},
							completion = {
								callSnippet = "Replace",
							},
							telemetry = { enable = false },
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				},
                                ruff = {
                                    filetypes = { "py", "python" },
                                },
			}

			-- Ensure the servers and tools above are installed
			require("mason").setup()
			vim.list_extend(ensure_installed, {
				-- LSP's
				"ts_ls",
				"vue_ls",
				"html",
				"cssls",
				"tailwindcss",
				"basedpyright",

				-- Formatters (Best & Fastest)
				"fixjson",
				"mdformat",
				"prettierd", -- Fastest for JS/TS/Web
				"ruff", -- Python formatter & linter (fastest)
				"shfmt",
				"stylua",

				-- Linters (Best & Fastest)
				"checkstyle",
				"eslint_d", -- Fastest for JS/TS

				-- Additional tools
				"ast-grep",
				"tree-sitter-cli",
				"semgrep",
			})

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},

	--- Auto Format
	{
		"stevearc/conform.nvim",
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				-- JavaScript/TypeScript/Web (prettierd is fastest)
				javascript = { "prettierd", "eslint_d" },
				javascriptreact = { "prettierd", "eslint_d" },
				typescript = { "prettierd", "eslint_d" },
				typescriptreact = { "prettierd", "eslint_d" },
				vue = { "prettierd", "eslint_d" },
				html = { "prettierd" },
				css = { "prettierd", "rustywind" },
				scss = { "prettierd" },
				less = { "prettierd" },
				json = { "prettierd", "fixjson" },
				jsonc = { "prettierd" },
				yaml = { "prettierd" },
				graphql = { "prettierd" },

				-- Python (ruff is fastest)
				python = { "ruff_format", "ruff_organize_imports" },

				-- Go
				go = { "goimports", "gofumpt" },
				gomod = { "goimports" },
				gowork = { "goimports" },

				-- Rust
				rust = { "rustfmt" },

				-- Java/Kotlin
				java = { "google-java-format" },
				kotlin = { "ktfmt" },
				groovy = { "npm-groovy-lint" },

				-- C/C++
				c = { "clang-format" },
				cpp = { "clang-format" },

				-- Shell
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },

				-- Lua
				lua = { "stylua" },

				-- SQL
				sql = { "pgformatter", "sql-formatter" },
				mysql = { "sql-formatter" },
				postgresql = { "pgformatter" },

				-- Document/Markup
				markdown = { "prettierd", "mdformat" },
				["markdown.mdx"] = { "prettierd" },
				tex = { "latexindent" },
				plaintex = { "latexindent" },

				-- Functional Languages
				ocaml = { "ocamlformat" },
				haskell = { "fourmolu" },

				-- Other
				asm = { "asmfmt" },
				dockerfile = { "dockerfile" },
				toml = { "taplo" },
				dart = { "dart_format" },
			},
		},
	},

	--- AutoComplete
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			-- Snippet Engine
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					-- {
					--   'rafamadriz/friendly-snippets',
					--   config = function()
					--     require('luasnip.loaders.from_vscode').lazy_load()
					--   end,
					-- },
				},
				opts = {},
			},
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				-- 'default' (recommended) for mappings similar to built-in completions
				--   <c-y> to accept ([y]es) the completion.
				--    This will auto-import if your LSP supports it.
				--    This will expand snippets if the LSP sent a snippet.
				-- 'super-tab' for tab to accept
				-- 'enter' for enter to accept
				-- 'none' for no mappings
				--
				-- For an understanding of why the 'default' preset is recommended,
				-- you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				--
				-- All presets have the following mappings:
				-- <tab>/<s-tab>: move to right/left of your snippet expansion
				-- <c-space>: Open menu or open docs if already open
				-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
				-- <c-e>: Hide menu
				-- <c-k>: Toggle signature help
				--
				-- See :h blink-cmp-config-keymap for defining your own keymap
				preset = "default",

				-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
				--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = {
				-- By default, you may press `<c-space>` to show the documentation.
				-- Optionally, set `auto_show = true` to show the documentation after a delay.
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
				menu = {
					draw = {
						columns = {
							{ "kind_icon" },
							{ "label", "label_description", gap = 1 },
							{ "source_name" }, -- Include this to display the source name
						},
						treesitter = { "lsp" },
					},
				},
			},

			sources = {
				default = { "lsp", "path", "snippets" },
			},

			snippets = { preset = "luasnip" },

			-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
			-- which automatically downloads a prebuilt binary when enabled.
			--
			-- By default, we use the Lua implementation instead, but you may enable
			-- the rust implementation via `'prefer_rust_with_warning'`
			--
			-- See :h blink-cmp-config-fuzzy for more information
			fuzzy = { implementation = "lua" },

			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
	},

	--- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
				"vue",
				"typescript",
				"javascript",
				"python",
				"bash",
				"json",
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = {
					"bash",
					"c",
					"diff",
					"html",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"query",
					"vim",
					"vimdoc",
					"vue",
					"typescript",
					"javascript",
					"python",
					"bash",
					"json",
				},
			},
			indent = { enable = true, disable = { "ruby" } },
		},
		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		--
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	},
}
