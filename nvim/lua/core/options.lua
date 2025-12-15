-- ui / display
vim.opt.termguicolors = true        -- enable true color
vim.wo.number = true               -- absolute line numbers
vim.o.relativenumber = true        -- relative line numbers
vim.o.numberwidth = 4              -- number column width
vim.o.cursorline = true            -- highlight current line
vim.wo.signcolumn = 'yes'          -- always show signcolumn
vim.o.showmode = false             -- hide mode text
vim.o.showtabline = 1              -- show tabline only if needed
vim.o.cmdheight = 1                -- compact command line
vim.o.conceallevel = 0             -- show markdown backticks

-- window / scrolling
vim.o.wrap = false                 -- disable line wrap
vim.o.linebreak = true             -- prevent word breaking
vim.o.scrolloff = 4                -- context above/below cursor
vim.o.sidescrolloff = 8            -- context left/right
vim.o.splitbelow = true            -- horizontal splits below
vim.o.splitright = true            -- vertical splits right

-- mouse / clipboard
vim.o.mouse = 'a'                  -- enable mouse
vim.o.clipboard = 'unnamedplus'    -- sync system clipboard

-- indentation / tabs
vim.o.expandtab = true             -- tabs to spaces
vim.o.shiftwidth = 2               -- indent size
vim.o.tabstop = 4                  -- tab width
vim.o.softtabstop = 2              -- editing tab width
vim.o.smartindent = true           -- smarter indentation
vim.o.autoindent = true            -- copy indent from current line
vim.o.breakindent = true           -- wrapped line indentation

-- search
vim.o.hlsearch = true              -- highlight matches
vim.o.ignorecase = true            -- case-insensitive search
vim.o.smartcase = true             -- smart case search

-- undo / backup / swap
vim.o.undofile = true              -- persistent undo
vim.o.backup = false               -- disable backup file
vim.o.writebackup = false          -- disable write backup
vim.o.swapfile = false             -- disable swap file

-- completion / popup
vim.o.completeopt = 'menuone,noselect' -- better completion UX
vim.o.pumheight = 10                   -- popup menu height
vim.opt.shortmess:append 'c'           -- suppress completion messages

-- timing / responsiveness
vim.o.updatetime = 250             -- faster CursorHold
vim.o.timeoutlen = 300             -- key sequence timeout

-- movement behavior
vim.o.whichwrap = 'bs<>[]hl'       -- allow wrap movement
vim.o.backspace = 'indent,eol,start' -- sane backspace

-- file handling
vim.o.fileencoding = 'utf-8'       -- file encoding

-- text formatting
vim.opt.formatoptions:remove { 'c', 'r', 'o' } -- no auto comment insertion

-- keyword rules
vim.opt.iskeyword:append '-'       -- treat hyphenated words as one

-- runtime path cleanup
vim.opt.runtimepath:remove '/usr/share/vim/vimfiles' -- avoid vim plugin bleed

