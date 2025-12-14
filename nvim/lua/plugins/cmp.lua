return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets", -- VSCode-style snippets
  },

  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- Load VSCode-style snippets lazily
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Persistent toggle for autocomplete
    local state_file = vim.fn.stdpath("data") .. "/cmp_state.txt"
    local autocomplete_active = true
    if vim.fn.filereadable(state_file) == 1 then
      autocomplete_active = vim.fn.readfile(state_file)[1] == "true"
    end

    -- Helper for dynamic enabled state
    local function is_enabled()
      return autocomplete_active
    end

    -- Main nvim-cmp configuration
    cmp.setup({
      enabled = is_enabled,

      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      formatting = {
        format = function(entry, item)
          local labels = {
            nvim_lsp = "[LSP]",
            luasnip  = "[Snip]",
            buffer   = "[Buf]",
            path     = "[Path]",
          }
          item.menu = labels[entry.source.name]
          return item
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),

        ["<S-CR>"] = cmp.mapping.confirm({ select = true }),

        ["<CR>"] = cmp.mapping(function(fallback)
          fallback()
        end, { "i", "s" }),

        ["<Tab>"] = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end,

        ["<S-Tab>"] = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end,
      }),

      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
        { name = "path" },
      }),
    })

    -- Toggle autocomplete quickly
    vim.keymap.set("n", "<leader>ta", function()
      autocomplete_active = not autocomplete_active
      vim.fn.writefile({ tostring(autocomplete_active) }, state_file)
      cmp.setup({ enabled = is_enabled })
      print(autocomplete_active and " Autocomplete: ON" or " Autocomplete: OFF")
    end, { desc = "Toggle autocomplete" })
  end,
}

