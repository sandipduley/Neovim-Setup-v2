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

		-- Ensure external formatters are installed
		mason_null_ls.setup({
			ensure_installed = {
				"prettier",
				"stylua",
				-- "bash-language-server",
				-- "shfmt",
				-- "gofumpt",
				-- "goimports",
				-- "sqlfluff",
				"eslint-lsp",
			},
			automatic_installation = true,
		})

		-- Formatters and linters only (no LSP overlap)
		null_ls.setup({
			sources = {
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
					},
				}),

				formatting.stylua,

				require("none-ls.formatting.ruff_format"),

				formatting.gofumpt,
				formatting.goimports,

				formatting.shfmt,

				formatting.sqlfluff.with({
					extra_args = { "--dialect", "mysql" },
				}),
				diagnostics.sqlfluff,
			},
		})
	end,
}
