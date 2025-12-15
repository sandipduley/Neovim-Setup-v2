-- Telescope: Optimized Fuzzy Finder & LSP Integration
return {
  'nvim-telescope/telescope.nvim',
  branch = 'master',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',

    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function() return vim.fn.executable 'make' == 1 end,
    },

    'nvim-telescope/telescope-ui-select.nvim',
  },

  config = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')
    local actions = require('telescope.actions')
    local themes = require('telescope.themes')

    -- Helper function for keymaps
    local function map_keys(maps)
      for mode, bindings in pairs(maps) do
        for key, action in pairs(bindings) do
          vim.keymap.set(mode, key, action, { silent = true, noremap = true })
        end
      end
    end

    -- Telescope Setup
    telescope.setup {
      defaults = {
        layout_strategy = 'horizontal',
        layout_config = {
          horizontal = {
            prompt_position = 'bottom',
            preview_width = 0.6,
            width = { padding = 0 },
            height = { padding = 0 },
          },
        },
        mappings = {
          i = {
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-l>'] = actions.select_default,
            ['<C-c>'] = actions.close,
          },
          n = { ['q'] = actions.close },
        },
        path_display = { filename_first = { reverse_directories = true } },
      },

      pickers = {
        find_files = { hidden = true, file_ignore_patterns = { 'node_modules', '.git', '.venv' } },
        buffers = {
          initial_mode = 'normal',
          sort_lastused = true,
          mappings = { n = { ['d'] = actions.delete_buffer, ['l'] = actions.select_default } },
        },
        marks = { initial_mode = 'normal' },
        oldfiles = { initial_mode = 'normal' },
      },

      extensions = {
        ['ui-select'] = themes.get_dropdown(),
      },
    }

    -- Load extensions safely
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')

    -- Optimized keymaps
    map_keys {
      n = {
        -- Buffers & Marks
        ['<leader>sb'] = builtin.buffers,
        ['<leader><tab>'] = builtin.buffers,
        ['<leader>bb'] = builtin.buffers,
        ['<leader>sm'] = builtin.marks,
        ['<leader>so'] = builtin.oldfiles,

        -- Git
        ['<leader>gf'] = builtin.git_files,
        ['<leader>gc'] = builtin.git_commits,
        ['<leader>gcf'] = builtin.git_bcommits,
        ['<leader>gb'] = builtin.git_branches,
        ['<leader>gs'] = builtin.git_status,

        -- Search
        ['<leader>sf'] = builtin.find_files,
        ['<leader>sh'] = builtin.help_tags,
        ['<leader>gs'] = builtin.grep_string,
        ['<leader>gl'] = builtin.live_grep,
        ['<leader>sd'] = builtin.diagnostics,
        ['<leader>sr'] = builtin.resume,

        -- LSP Symbols
        ['<leader>sds'] = function()
          builtin.lsp_document_symbols {
            symbols = { 'Class', 'Function', 'Method', 'Constructor', 'Interface', 'Module', 'Property' },
          }
        end,

        -- Open files only
        ['<leader>s/'] = function()
          builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
        end,

        -- Fuzzy search current buffer
        ['<leader>/'] = function()
          builtin.current_buffer_fuzzy_find(themes.get_dropdown { previewer = false })
        end,
      },
    }
  end,
}


