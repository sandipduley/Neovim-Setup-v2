-- leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- common options
local opts = { noremap = true, silent = true }

-- disable default space behavior
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', opts)

-- smooth movement on wrapped lines
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- keep cursor centered
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- clear search highlight
vim.keymap.set('n', '<Esc>', '<cmd>noh<CR>', opts)

-- save / quit
vim.keymap.set('n', '<C-s>', '<cmd>w<CR>', opts)
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w<CR>', opts)
vim.keymap.set('n', '<C-q>', '<cmd>q<CR>', opts)

-- editing helpers
vim.keymap.set('n', 'x', '"_x', opts)
vim.keymap.set('n', '<leader>+', '<C-a>', opts)
vim.keymap.set('n', '<leader>-', '<C-x>', opts)

-- window splits
vim.keymap.set('n', '<leader>v', '<C-w>v', opts)
vim.keymap.set('n', '<leader>h', '<C-w>s', opts)
vim.keymap.set('n', '<leader>se', '<C-w>=', opts)
vim.keymap.set('n', '<leader>sx', '<cmd>close<CR>', opts)

-- window navigation
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- window resize
vim.keymap.set('n', '<Up>', '<cmd>resize -2<CR>', opts)
vim.keymap.set('n', '<Down>', '<cmd>resize +2<CR>', opts)
vim.keymap.set('n', '<Left>', '<cmd>vertical resize -2<CR>', opts)
vim.keymap.set('n', '<Right>', '<cmd>vertical resize +2<CR>', opts)

-- buffers
vim.keymap.set('n', '<Tab>', '<cmd>bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', '<cmd>bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', '<cmd>Bdelete!<CR>', opts)
vim.keymap.set('n', '<leader>b', '<cmd>enew<CR>', opts)
vim.keymap.set('n', '<C-i>', '<C-i>', opts)

-- tabs
vim.keymap.set('n', '<leader>ot', '<cmd>tabnew<CR>', opts)
vim.keymap.set('n', '<leader>xt', '<cmd>tabclose<CR>', opts)
vim.keymap.set('n', '<leader>nt', '<cmd>tabn<CR>', opts)
vim.keymap.set('n', '<leader>pt', '<cmd>tabp<CR>', opts)

-- insert mode escape
vim.keymap.set('i', 'jj', '<ESC>', opts)
vim.keymap.set('i', 'kj', '<ESC>', opts)

-- visual mode helpers
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)
vim.keymap.set('v', '<A-j>', ':m .+1<CR>==', opts)
vim.keymap.set('v', '<A-k>', ':m .-2<CR>==', opts)
vim.keymap.set('v', 'p', '"_dP', opts)

-- clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])

-- misc utilities
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)
vim.keymap.set('n', '<leader>j', '*``cgn', opts)

-- diagnostics toggle
local diagnostics_enabled = true
vim.keymap.set('n', '<leader>do', function()
  diagnostics_enabled = not diagnostics_enabled
  vim.diagnostic.enable(diagnostics_enabled)
end)

-- diagnostics navigation
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end)

vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end)

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- sessions
vim.keymap.set('n', '<leader>ss', '<cmd>mksession! .session.vim<CR>', { silent = false })
vim.keymap.set('n', '<leader>sl', '<cmd>source .session.vim<CR>', { silent = false })

-- tiny-inline-diagnostics
vim.keymap.set('n', '<leader>ed', '<cmd>TinyInlineDiag enable<CR>')
vim.keymap.set('n', '<leader>dd', '<cmd>TinyInlineDiag disable<CR>')
vim.keymap.set('n', '<leader>td', '<cmd>TinyInlineDiag toggle<CR>')

-- disable arrow keys in insert mode
vim.keymap.set('i', '<Up>', '<Nop>', opts)
vim.keymap.set('i', '<Down>', '<Nop>', opts)
-- vim.keymap.set('i', '<Left>', '<Nop>', opts)
-- vim.keymap.set('i', '<Right>', '<Nop>', opts)

