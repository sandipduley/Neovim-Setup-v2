-- Highlight, edit, and navigate code
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  config = function()
    local ts_config = require('nvim-treesitter.configs')

    ts_config.setup {
      -- Languages to install
      ensure_installed = {
        'bash', 
        'c', 
        'css', 
        'dockerfile', 
        'go', 
        'html', 
        'javascript', 
        'json',
        'lua', 
        'markdown', 
        'markdown_inline', 
        'python', 
        'regex', 
        'toml',
        'vim', 
        'vimdoc', 
        'yaml', 
        'gitignore',
      },

      -- Automatically install missing parsers
      auto_install = true,

      -- Core features
      highlight = { enable = true },
      indent = { enable = true },

      -- Incremental selection
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = '<c-s>',
          node_decremental = '<M-space>',
        },
      },

      -- Text objects
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Jump forward automatically
          keymaps = {
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = { ['<leader>a'] = '@parameter.inner' },
          swap_previous = { ['<leader>A'] = '@parameter.inner' },
        },
      },
    }
  end,
}

