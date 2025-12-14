-- prevent LSP from overwriting Treesitter colors
vim.hl.priorities.semantic_tokens = 95

-- configure diagnostics
vim.diagnostic.config {
  virtual_text = {
    prefix = '●',
    format = function(diagnostic)
      local code = diagnostic.code and string.format('[%s]', diagnostic.code) or ''
      return string.format('%s %s', code, diagnostic.message)
    end,
  },
  underline = false,
  update_in_insert = true,
  float = { source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN]  = ' ',
      [vim.diagnostic.severity.INFO]  = ' ',
      [vim.diagnostic.severity.HINT]  = '󰌵 ',
    },
  },
  on_ready = function()
    vim.cmd 'highlight DiagnosticVirtualText guibg=NONE'
  end,
}

-- highlight yanked text
local yank_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.hl.on_yank() end,
  group = yank_group,
  pattern = '*',
})

-- kitty terminal padding tweaks
vim.cmd [[
  augroup KittyPadding
    autocmd!
    autocmd VimEnter * :silent !kitty @ set-spacing padding=0 margin=0 3 0 3
    autocmd VimLeave * :silent !kitty @ set-spacing padding=default margin=default
  augroup END
]]

