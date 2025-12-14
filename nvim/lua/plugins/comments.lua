-- Comment lines or visual selections easily
return {
  'numToStr/Comment.nvim',
  opts = {},
  config = function()
    local key_opts = { noremap = true, silent = true }

    -- Normal mode toggles
    vim.keymap.set('n', '<C-_>', require('Comment.api').toggle.linewise.current, key_opts)
    vim.keymap.set('n', '<C-c>', require('Comment.api').toggle.linewise.current, key_opts)
    vim.keymap.set('n', '<C-/>', require('Comment.api').toggle.linewise.current, key_opts)

    -- Visual mode toggles
    local visual_toggle = "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>"
    vim.keymap.set('v', '<C-/>', visual_toggle, key_opts)
  end,
}

