return {
	"nvimtools/none-ls.nvim",

	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim",
	},

	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics

		-- Install formatters and linters automatically
		require("mason-null-ls").setup({
			ensure_installed = {
				"checkmake",
				"prettier",
				"eslint_d",
				"shfmt",
				-- "stylua",
				-- "ruff",
				-- "gofmt",
				-- "gopls",
				-- "goimports",
				-- "golangci_lint",
				"shellcheck",
			},
			automatic_installation = true,
		})

		-- Tools used for formatting and diagnostics
		local sources = {
			diagnostics.checkmake,

			-- JS / TS / Web files
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

			-- Lua formatter
			formatting.stylua,

			-- Shell format & lint
			formatting.shfmt.with({ args = { "-i", "4" } }),
			diagnostics.shellcheck,

			-- Python (ruff formatter + ruff format)
			require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
			require("none-ls.formatting.ruff_format"),

			-- Go formatters & linter
			formatting.gofumpt,
			formatting.goimports_reviser,
			diagnostics.golangci_lint,

			-- SQL formatter & linter
			formatting.sqlfluff.with({ extra_args = { "--dialect", "mysql" } }),
			diagnostics.sqlfluff,
		}

		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		-- Setup null-ls and autoformat on save
		null_ls.setup({
			sources = sources,

			on_attach = function(client, bufnr)
				-- Check if the attached client can format
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

					-- Format file before saving
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end,
					})
				end
			end,
		})
	end,
}
