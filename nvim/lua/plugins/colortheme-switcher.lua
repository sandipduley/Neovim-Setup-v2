return {
	{
		"folke/tokyonight.nvim",
		lazy = true,
	},
	{
		"tiagovla/tokyodark.nvim",
		lazy = true,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
	},
	{
		"ellisonleao/gruvbox.nvim",
		lazy = true,
	},
	{
		"navarasu/onedark.nvim",
		lazy = true,
	},
	{
		"sainnhe/everforest",
		lazy = true,
	},
	{
		"Mofiqul/dracula.nvim",
		lazy = true,
	},
	{
		"bluz71/vim-nightfly-colors",
		lazy = true,
	},
	{
		"samharju/synthweave.nvim",
		lazy = true,
	},
	{
		"Tsuzat/NeoSolarized.nvim",
		lazy = true,
	},
	{
		"maxmx03/fluoromachine.nvim",
		lazy = true,
	},

	{
		"zaldih/themery.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			-- load last theme
			pcall(function()
				require("themery").loadTheme()
			end)

			require("themery").setup({
				themes = {
					{ name = "Tokyo Night", colorscheme = "tokyonight" },
					{ name = "Tokyo Dark", colorscheme = "tokyodark" },
					{ name = "Catppuccin Mocha", colorscheme = "catppuccin-mocha" },
					{ name = "Gruvbox", colorscheme = "gruvbox" },
					{ name = "OneDark", colorscheme = "onedark" },
					{ name = "Everforest", colorscheme = "everforest" },
					{ name = "Dracula", colorscheme = "dracula" },
					{ name = "Dracula Soft", colorscheme = "dracula-soft" },
					{ name = "Nightfly", colorscheme = "nightfly" },
					{ name = "Synthweave", colorscheme = "synthweave" },
					{ name = "NeoSolarized", colorscheme = "NeoSolarized" },
					{ name = "Fluoromachine", colorscheme = "fluoromachine" },
				},
				livePreview = true,
			})

			-- Keymap
			vim.keymap.set("n", "<leader>ct", "<cmd>Themery<CR>", { desc = "Theme Switcher" })
		end,
	},
}
