return {
	"nvim-lualine/lualine.nvim",
	config = function()
		-- Colors & Theme

		local colors = {
			bg = "#2a2f45",
			fg = "#f0f0f0",

			red = "#ff859f",
			orange = "#ffb987",
			yellow = "#f6d98a",
			green = "#17E68A",
			blue = "#8ab4ff",
			purple = "#dd9cf0",
			cyan = "#7ee6ed",

			gray1 = "#b0b6c9",
			gray2 = "#343a55",
			gray3 = "#424a6b",
		}

		local custom_theme = {
			normal = {
				a = { fg = colors.bg, bg = colors.green, gui = "bold" },
				b = { fg = colors.fg, bg = colors.gray3 },
				c = { fg = colors.fg, bg = colors.gray2 },
			},
			insert = { a = { fg = colors.bg, bg = colors.blue, gui = "bold" } },
			visual = { a = { fg = colors.bg, bg = colors.purple, gui = "bold" } },
			replace = { a = { fg = colors.bg, bg = colors.red, gui = "bold" } },
			terminal = { a = { fg = colors.bg, bg = colors.cyan, gui = "bold" } },
			command = { a = { fg = colors.bg, bg = colors.orange, gui = "bold" } },
			inactive = {
				a = { fg = colors.gray1, bg = colors.bg, gui = "bold" },
				b = { fg = colors.gray1, bg = colors.bg },
				c = { fg = colors.gray1, bg = colors.gray2 },
			},
		}

		local theme_choice = os.getenv("NVIM_THEME") or "custom"

		-- Helper Functions

		local visible_if_wide = function()
			return vim.fn.winwidth(0) > 100
		end

		-- Components

		local mode_component = {
			"mode",
			fmt = function(str)
				return visible_if_wide() and (" " .. str) or (" " .. str:sub(1, 1))
			end,
		}

		local file_component = { "filename", file_status = true, path = 1 }

		local diagnostic_component = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn" },
			symbols = { error = " ", warn = " ", info = " ", hint = " " },
			colored = true,
			update_in_insert = true,
			cond = visible_if_wide,
		}

		local diff_component = {
			"diff",
			colored = true,
			symbols = { added = " ", modified = "柳 ", removed = " " },
			cond = visible_if_wide,
		}

		-- Lualine Setup

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = theme_choice == "custom" and custom_theme or theme_choice,
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				disabled_filetypes = { "alpha", "neo-tree", "Avante" },
				always_divide_middle = true,
			},
			sections = {
				lualine_a = { mode_component },
				lualine_b = { "branch" },
				lualine_c = { file_component },
				lualine_x = {
					diagnostic_component,
					diff_component,
					{ "encoding", cond = visible_if_wide },
					{ "filetype", cond = visible_if_wide },
				},
				lualine_y = { "location" },
				lualine_z = { "progress" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { file_component },
				lualine_x = { { "location", padding = 0 } },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "fugitive" },
		})
	end,
}
