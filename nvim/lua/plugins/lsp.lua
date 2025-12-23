return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },

  dependencies = {
    { "mason-org/mason.nvim", config = true },
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "hrsh7th/cmp-nvim-lsp",
    {
      "j-hui/fidget.nvim",
      opts = { notification = { window = { winblend = 0 } } },
    },
  },

  config = function()
    local lsp = vim.lsp
    local api = vim.api
    local tb = require("telescope.builtin")

    -- Augroups

    local attach_group   = api.nvim_create_augroup("LspAttach", { clear = true })
    local highlight_group = api.nvim_create_augroup("LspHighlight", { clear = true })
    local format_group   = api.nvim_create_augroup("LspFormat", { clear = true })

    -- LSP Attach

    api.nvim_create_autocmd("LspAttach", {
      group = attach_group,
      callback = function(event)
        local buf = event.buf
        local client = lsp.get_client_by_id(event.data.client_id)

        local map = function(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = buf, desc = "LSP: " .. desc })
        end

        -- Navigation (Telescope)
        map("gd", tb.lsp_definitions, "Goto Definition")
        map("gr", tb.lsp_references, "Goto References")
        map("gI", tb.lsp_implementations, "Goto Implementation")
        map("<leader>D", tb.lsp_type_definitions, "Type Definition")
        map("<leader>ds", tb.lsp_document_symbols, "Document Symbols")
        map("<leader>ws", tb.lsp_dynamic_workspace_symbols, "Workspace Symbols")

        -- Core
        map("<leader>rn", lsp.buf.rename, "Rename")
        map("<leader>ca", lsp.buf.code_action, "Code Action")
        map("K", lsp.buf.hover, "Hover")
        map("gD", lsp.buf.declaration, "Goto Declaration")

        -- Workspace
        map("<leader>wa", lsp.buf.add_workspace_folder, "Workspace Add")
        map("<leader>wr", lsp.buf.remove_workspace_folder, "Workspace Remove")
        map("<leader>wl", function()
          print(vim.inspect(lsp.buf.list_workspace_folders()))
        end, "Workspace List")

        -- Document Highlight
        if client and client.supports_method(lsp.protocol.Methods.textDocument_documentHighlight) then
          api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = buf,
            group = highlight_group,
            callback = lsp.buf.document_highlight,
          })

          api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = buf,
            group = highlight_group,
            callback = lsp.buf.clear_references,
          })
        end

        -- Inlay hints
        if client and client.supports_method(lsp.protocol.Methods.textDocument_inlayHint) then
          map("<leader>th", function()
            lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled { bufnr = buf })
          end, "Toggle Inlay Hints")
        end

        -- Format on save (safe)
        if client and client.supports_method("textDocument/formatting") then
          api.nvim_clear_autocmds { group = format_group, buffer = buf }

          api.nvim_create_autocmd("BufWritePre", {
            group = format_group,
            buffer = buf,
            callback = function()
              lsp.buf.format {
                bufnr = buf,
                async = false,
                filter = function(c)
                  return c.name ~= "tsserver" -- avoid formatter conflicts
                end,
              }
            end,
          })
        end
      end,
    })

    -- Capabilities

    local capabilities = vim.tbl_deep_extend(
      "force",
      lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities()
    )

    -- Servers

    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            completion = { callSnippet = "Replace" },
            diagnostics = { globals = { "vim" }, disable = { "missing-fields" } },
            workspace = {
              checkThirdParty = false,
              library = api.nvim_get_runtime_file("", true),
            },
            format = { enable = false },
          },
        },
      },

      -- pyright = {
      --   settings = {
      --     python = {
      --       analysis = {
      --         typeCheckingMode = "strict",
      --         diagnosticMode = "workspace",
      --       },
      --     },
      --   },
      -- },
      --
      -- ruff = {},
      --
      -- bashls = {
      --   settings = {
      --     bashIde = {
      --       globPattern = "**/*@(.sh|.inc|.bash|.command)",
      --     },
      --   },
      -- },
      --
      -- dockerls = {},
      -- docker_compose_language_service = {},
      --
      -- gopls = {
      --   settings = {
      --     gopls = {
      --       gofumpt = true,
      --       staticcheck = true,
      --     },
      --   },
      -- },
      --
      -- ts_ls = {
      --   settings = {
      --     javascript = { format = { enable = true } },
      --     typescript = { format = { enable = true } },
      --   },
      -- },
    }

    -- Mason Installer

    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, { "stylua" })

    require("mason-tool-installer").setup {
      ensure_installed = ensure_installed,
    }

    -- Register Servers

    for name, cfg in pairs(servers) do
      cfg.capabilities = capabilities
      vim.lsp.config(name, cfg)
      vim.lsp.enable(name)
    end
  end,
}

