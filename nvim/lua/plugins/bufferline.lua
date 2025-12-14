return {
  'akinsho/bufferline.nvim',
  dependencies = {
    'moll/vim-bbye',               -- close buffers without closing window
    'nvim-tree/nvim-web-devicons', -- filetype icons
  },

  config = function()
    local bufferline = require('bufferline')

    bufferline.setup {
      options = {
        mode = 'buffers',
        themable = true,
        numbers = 'none',

        close_command = 'Bdelete! %d',
        right_mouse_command = 'Bdelete! %d',
        left_mouse_command = 'buffer %d',
        middle_mouse_command = nil,

        buffer_close_icon = '✗',
        close_icon = '',

        path_components = 1,
        modified_icon = '●',
        left_trunc_marker = '',
        right_trunc_marker = '',

        max_name_length = 30,
        max_prefix_length = 30,
        tab_size = 21,

        diagnostics = false,
        diagnostics_update_in_insert = false,

        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        persist_buffer_sort = true,

        separator_style = { '│', '│' },
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        show_tab_indicators = false,

        indicator = { style = 'underline' },
        icon_pinned = '󰐃',

        minimum_padding = 1,
        maximum_padding = 5,
        maximum_length = 15,

        sort_by = 'insert_at_end',
      },

      highlights = {
        separator = { fg = '#434C5E' },
        buffer_selected = { bold = true, italic = false },
      },
    }

    local opts = { noremap = true, silent = true, desc = 'Go to Buffer' }

    -- Cycle buffers
    vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', opts)
    vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', opts)

    -- Jump to specific buffers
    for i = 1, 9 do
      vim.keymap.set('n', '<leader>' .. i, string.format(
        "<cmd>lua require('bufferline').go_to_buffer(%d)<CR>", i
      ), opts)
    end
  end,
}

