return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    config = function()
      -- Disable default virtual text (so tiny-inline handles diagnostics)
      vim.diagnostic.config({
        virtual_text = false,
      })

      require("tiny-inline-diagnostic").setup({
        -- Choose UI style
        preset = "ghost",

        -- Transparency options
        transparent_bg = false,
        transparent_cursorline = true,

        -- Highlight groups used by the plugin
        highlight = {
          error = "DiagnosticError",
          warn = "DiagnosticWarn",
          info = "DiagnosticInfo",
          hint = "DiagnosticHint",
          arrow = "NonText",
          background = "CursorLine",
          mixing_color = "Normal",
        },

        -- Disable plugin for specific filetypes
        disabled_ft = {},

        options = {
          -- Show diagnostic source (e.g., "lua_ls")
          show_source = {
            enabled = true,
            if_many = false,
          },

          -- Icon behavior
          use_icons_from_diagnostic = false,
          set_arrow_to_diag_color = false,

          -- Performance + wrapping
          throttle = 20,
          softwrap = 30,

          -- Message display settings
          add_messages = {
            messages = true,
            display_count = false,
            use_max_severity = false,
            show_multiple_glyphs = true,
          },

          -- Multiline diagnostic settings
          multilines = {
            enabled = true,
            always_show = true,
            trim_whitespaces = false,
            tabstop = 4,
            severity = nil,
          },

          -- Cursor behavior
          show_all_diags_on_cursorline = false,
          show_diags_only_under_cursor = false,

          -- LSP relatedInformation support
          show_related = {
            enabled = true,
            max_count = 6,
          },

          -- Show diagnostics during insert/select mode
          enable_on_insert = true,
          enable_on_select = true,

          -- Handle long lines
          overflow = {
            mode = "wrap",
            padding = 0,
          },

          break_line = {
            enabled = false,
            after = 30,
          },

          -- Custom formatting function (optional)
          format = nil,

          -- Priority for virtual text layers
          virt_texts = {
            priority = 2048,
          },

          -- Severity filter (show all)
          severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.INFO,
            vim.diagnostic.severity.HINT,
          },

          -- Auto-detection events
          overwrite_events = nil,

          -- Disable diagnostics when opening floats
          override_open_float = false,
        },
      })
    end,
  },
}

