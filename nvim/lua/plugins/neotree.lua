return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  event = 'VeryLazy',

  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    '3rd/image.nvim',

    {
      's1n7ax/nvim-window-picker',
      version = '2.*',
      config = function()
        require('window-picker').setup {
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            bo = {
              filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
              buftype = { 'terminal', 'quickfix' },
            },
          },
        }
      end,
      keys = {
        { '<leader>w', ':Neotree toggle float<CR>',  silent = true, desc = 'Float File Explorer' },
        { '<leader>e', ':Neotree toggle position=left<CR>', silent = true, desc = 'Left File Explorer' },
        { '<leader>ngs', ':Neotree float git_status<CR>', silent = true, desc = 'Git Status Window' },
      },
    },
  },

  config = function()
    local neotree = require('neo-tree')

    -- Reusable order-by mappings
    local order_by_mappings = {
      ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
      ['oc'] = { 'order_by_created' },
      ['od'] = { 'order_by_diagnostics' },
      ['om'] = { 'order_by_modified' },
      ['on'] = { 'order_by_name' },
      ['os'] = { 'order_by_size' },
      ['ot'] = { 'order_by_type' },
    }

    neotree.setup {
      close_if_last_window = false,
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = true,
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
      sort_case_insensitive = false,

      default_component_configs = {
        container = { enable_character_fade = true },
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = '│',
          last_indent_marker = '└',
          highlight = 'NeoTreeIndentMarker',
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        icon = {
          folder_closed = '',
          folder_open = '',
          folder_empty = '󰜌',
          default = '*',
          highlight = 'NeoTreeFileIcon',
        },
        modified = { symbol = '[+]', highlight = 'NeoTreeModified' },
        name = { trailing_slash = false, use_git_status_colors = true, highlight = 'NeoTreeFileName' },
        git_status = {
          symbols = {
            added = '',
            modified = '',
            deleted = '✖',
            renamed = '󰁕',
            untracked = '',
            ignored = '',
            unstaged = '󰄱',
            staged = '',
            conflict = '',
          },
        },
        file_size = { enabled = true, required_width = 64 },
        type = { enabled = true, required_width = 122 },
        last_modified = { enabled = true, required_width = 88 },
        created = { enabled = true, required_width = 110 },
        symlink_target = { enabled = false },
      },

      window = {
        position = 'left',
        width = 40,
        mapping_options = { noremap = true, nowait = true },
        mappings = vim.tbl_extend('force', {
          ['<space>'] = { 'toggle_node', nowait = false },
          ['<2-LeftMouse>'] = 'open',
          ['<cr>'] = 'open',
          ['<esc>'] = 'cancel',
          ['P'] = { 'toggle_preview', config = { use_float = true } },
          ['l'] = 'open',
          ['S'] = 'open_split',
          ['s'] = 'open_vsplit',
          ['t'] = 'open_tabnew',
          ['w'] = 'open_with_window_picker',
          ['C'] = 'close_node',
          ['z'] = 'close_all_nodes',
          ['a'] = { 'add', config = { show_path = 'none' } },
          ['A'] = 'add_directory',
          ['d'] = 'delete',
          ['r'] = 'rename',
          ['y'] = 'copy_to_clipboard',
          ['x'] = 'cut_to_clipboard',
          ['p'] = 'paste_from_clipboard',
          ['c'] = 'copy',
          ['m'] = 'move',
          ['q'] = 'close_window',
          ['R'] = 'refresh',
          ['?'] = 'show_help',
          ['<'] = 'prev_source',
          ['>'] = 'next_source',
          ['i'] = 'show_file_details',
        }, order_by_mappings),
      },

      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
          hide_by_name = {
            '.DS_Store', 'thumbs.db', 'node_modules', '__pycache__', '.virtual_documents', '.git',
            '.python-version', '.venv',
          },
        },
        follow_current_file = { enabled = false, leave_dirs_open = false },
        group_empty_dirs = false,
        hijack_netrw_behavior = 'open_default',
        use_libuv_file_watcher = false,
        window = { mappings = vim.tbl_extend('force', {
          ['<bs>'] = 'navigate_up',
          ['.'] = 'set_root',
          ['H'] = 'toggle_hidden',
          ['/'] = 'fuzzy_finder',
          ['D'] = 'fuzzy_finder_directory',
          ['#'] = 'fuzzy_sorter',
          ['f'] = 'filter_on_submit',
          ['<c-x>'] = 'clear_filter',
          ['[g'] = 'prev_git_modified',
          [']g'] = 'next_git_modified',
        }, order_by_mappings) },
      },

      buffers = {
        follow_current_file = { enabled = true, leave_dirs_open = false },
        group_empty_dirs = true,
        show_unloaded = true,
        window = { mappings = vim.tbl_extend('force', {
          ['bd'] = 'buffer_delete',
          ['<bs>'] = 'navigate_up',
          ['.'] = 'set_root',
        }, order_by_mappings) },
      },

      git_status = {
        window = { position = 'float', mappings = vim.tbl_extend('force', {
          ['A'] = 'git_add_all',
          ['gu'] = 'git_unstage_file',
          ['ga'] = 'git_add_file',
          ['gr'] = 'git_revert_file',
          ['gc'] = 'git_commit',
          ['gp'] = 'git_push',
          ['gg'] = 'git_commit_and_push',
        }, order_by_mappings) },
      },
    }

    vim.keymap.set('n', '\\', ':Neotree reveal toggle<CR>', { noremap = true, silent = true })
  end,
}
