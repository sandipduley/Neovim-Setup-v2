return {
	"nvimtools/none-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },

	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim",
	},

	config = function()
		local null_ls = require("null-ls")
		local mason_null_ls = require("mason-null-ls")

		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics

		-- Mason: auto-install tools used by none-ls
		mason_null_ls.setup({
			ensure_installed = {
				-- General
				"checkmake",
				"prettier",
				"eslint_d",
				"shfmt",
				"shellcheck",
				"stylua",

				-- Python
				"ruff",

				-- Go
				"gofmt",
				"goimports",
				"golangci_lint",

				-- SQL
				"sqlfluff",
			},
			automatic_installation = true,
		})

		-- none-ls sources
		local sources = {
			-- Make
			diagnostics.checkmake,

			-- JS / TS / Web
			formatting.prettier.with({
				filetypes = {
					"html",
					"json",
					"yaml",
					"markdown",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"css",
					"scss",
					"vue",
					"svelte",
				},
			}),
			diagnostics.eslint_d,

			-- Shell
			formatting.shfmt.with({
				extra_args = { "-i", "4" },
			}),
			diagnostics.shellcheck,

			-- Python (ruff as formatter + import sorter)
			require("none-ls.formatting.ruff").with({
				extra_args = { "--extend-select", "I" },
			}),
			require("none-ls.formatting.ruff_format"),

			-- Go
			formatting.gofumpt,
			formatting.goimports,
			diagnostics.golangci_lint,

			-- SQL
			formatting.sqlfluff.with({
				extra_args = { "--dialect", "mysql" },
			}),
			diagnostics.sqlfluff,
		}

		local format_augroup = vim.api.nvim_create_augroup("NoneLsFormat", { clear = true })

		null_ls.setup({
			sources = sources,

			on_attach = function(client, bufnr)
				if not client.supports_method("textDocument/formatting") then
					return
				end

				vim.api.nvim_clear_autocmds({
					group = format_augroup,
					buffer = bufnr,
				})

				vim.api.nvim_create_autocmd("BufWritePre", {
					group = format_augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({
							bufnr = bufnr,
							async = false,
							filter = function(c)
								return c.name == "null-ls"
							end,
						})
					end,
				})
			end,
		})
	end,
}


