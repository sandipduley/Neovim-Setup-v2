return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },

	dependencies = {
		{ "mason-org/mason.nvim", config = true },
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/cmp-nvim-lsp",
		{
			"j-hui/fidget.nvim",
			opts = { notification = { window = { winblend = 0 } } },
		},
	},

	config = function()
		local lsp = vim.lsp
		local api = vim.api
		local tb = require("telescope.builtin")

		-- Shared augroups
		local attach_group = api.nvim_create_augroup("LspAttach", { clear = true })
		local highlight_group = api.nvim_create_augroup("LspHighlight", { clear = true })
		local format_group = api.nvim_create_augroup("LspFormat", { clear = true })

		-- Keymaps, highlights, and formatting on attach
		api.nvim_create_autocmd("LspAttach", {
			group = attach_group,
			callback = function(event)
				local buf = event.buf
				local client = lsp.get_client_by_id(event.data.client_id)

				local map = function(keys, fn, desc)
					vim.keymap.set("n", keys, fn, { buffer = buf, desc = "LSP: " .. desc })
				end

				-- Navigation
				map("gd", tb.lsp_definitions, "Goto Definition")
				map("gr", tb.lsp_references, "Goto References")
				map("gI", tb.lsp_implementations, "Goto Implementation")
				map("<leader>D", tb.lsp_type_definitions, "Type Definition")
				map("<leader>ds", tb.lsp_document_symbols, "Document Symbols")
				map("<leader>ws", tb.lsp_dynamic_workspace_symbols, "Workspace Symbols")

				-- Actions
				map("<leader>rn", lsp.buf.rename, "Rename")
				map("<leader>ca", lsp.buf.code_action, "Code Action")
				map("K", lsp.buf.hover, "Hover")
				map("gD", lsp.buf.declaration, "Goto Declaration")

				-- Symbol highlighting
				if client and client.supports_method(lsp.protocol.Methods.textDocument_documentHighlight) then
					api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = buf,
						group = highlight_group,
						callback = lsp.buf.document_highlight,
					})

					api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = buf,
						group = highlight_group,
						callback = lsp.buf.clear_references,
					})
				end

				-- Inlay hints toggle
				if client and client.supports_method(lsp.protocol.Methods.textDocument_inlayHint) then
					map("<leader>th", function()
						lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled({ bufnr = buf }))
					end, "Toggle Inlay Hints")
				end

				-- Format on save (delegated to none-ls)
				if client and client.supports_method("textDocument/formatting") then
					api.nvim_clear_autocmds({ group = format_group, buffer = buf })

					api.nvim_create_autocmd("BufWritePre", {
						group = format_group,
						buffer = buf,
						callback = function()
							lsp.buf.format({
								bufnr = buf,
								filter = function(c)
									return c.name == "null-ls"
								end,
							})
						end,
					})
				end
			end,
		})

		-- Capabilities for completion
		local capabilities = vim.tbl_deep_extend(
			"force",
			lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities()
		)

		-- LSP servers (diagnostics & intelligence only)
		local servers = {
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = {
							checkThirdParty = false,
							library = api.nvim_get_runtime_file("", true),
						},
						format = { enable = false },
					},
				},
			},

			pyright = {
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "strict",
							diagnosticMode = "workspace",
						},
					},
				},
			},

			gopls = {
				settings = {
					gopls = {
						gofumpt = false,
						staticcheck = true,
					},
				},
			},

			ts_ls = {
				settings = {
					javascript = { format = { enable = false } },
					typescript = { format = { enable = false } },
				},
			},

			html = {
				filetypes = { "html" },
			},

			-- React / JS / TS linting (optional but recommended)
			eslint = {
				settings = {
					workingDirectory = { mode = "auto" },
				},
			},

			-- Bash / shell scripts
			bashls = {
				settings = {
					bashIde = {
						globPattern = "**/*@(.sh|.bash|.zsh|.command)",
					},
				},
			},

			dockerls = {},
			docker_compose_language_service = {},
		}

		-- Ensure LSP servers are installed
		require("mason-tool-installer").setup({
			ensure_installed = vim.tbl_keys(servers),
		})

		-- Register and enable servers
		for name, cfg in pairs(servers) do
			cfg.capabilities = capabilities
			vim.lsp.config(name, cfg)
			vim.lsp.enable(name)
		end
	end,
}

