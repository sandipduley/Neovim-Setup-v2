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

		local formatting  = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics

		-- Mason: auto-install tools
		mason_null_ls.setup({
			ensure_installed = {
				"checkmake", "prettier", "eslint_d", "stylua"
				-- "shfmt",
				-- "ruff", 
				-- "gofmt", 
				-- "goimports", 
				-- "golangci_lint", 
				-- "sqlfluff",
			},
			automatic_installation = true,
		})

		-- Sources
		local sources = {
			diagnostics.checkmake,

			formatting.prettier.with({
				filetypes = {
					"html","json","yaml","markdown","javascript","javascriptreact",
					"typescript","typescriptreact","css","scss","vue","svelte",
				},
			}),
			diagnostics.eslint_d,

			formatting.shfmt.with({ extra_args = { "-i", "4" } }),
			diagnostics.shellcheck,

			require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
			require("none-ls.formatting.ruff_format"),

			formatting.gofumpt,
			formatting.goimports,
			diagnostics.golangci_lint,

			formatting.sqlfluff.with({ extra_args = { "--dialect", "mysql" } }),
			diagnostics.sqlfluff,
		}

		-- Format on Save
		local format_augroup = vim.api.nvim_create_augroup("NoneLsFormat", { clear = true })

		null_ls.setup({
			sources = sources,
			on_attach = function(client, bufnr)
				if not client.supports_method("textDocument/formatting") then return end

				vim.api.nvim_clear_autocmds({ group = format_augroup, buffer = bufnr })

				vim.api.nvim_create_autocmd("BufWritePre", {
					group = format_augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({
							bufnr = bufnr,
							async = false,
							filter = function(c) return c.name == "null-ls" end,
						})
					end,
				})
			end,
		})
	end,
}

