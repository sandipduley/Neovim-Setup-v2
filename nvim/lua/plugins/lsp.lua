return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },

  -- Dependencies
  dependencies = {
    { "mason-org/mason.nvim", config = true },
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "hrsh7th/cmp-nvim-lsp",

    {
      "j-hui/fidget.nvim",
      opts = {
        notification = { window = { winblend = 0 } },
      },
    },
  },

  config = function()
    local tb = require("telescope.builtin")


    -- Auto Command Groups

    local attach_group = vim.api.nvim_create_augroup("lsp-attach", { clear = true })
    local highlight_group = vim.api.nvim_create_augroup("kickstart-lsp-highlight", {})
    local detach_group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true })


    -- LSP Attach Function

    vim.api.nvim_create_autocmd("LspAttach", {
      group = attach_group,
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, {
            buffer = event.buf,
            desc = "LSP: " .. desc,
          })
        end

        -- Telescope-based navigation
        map("gd", tb.lsp_definitions, "[G]oto [D]efinition")
        map("gr", tb.lsp_references, "[G]oto [R]eferences")
        map("gI", tb.lsp_implementations, "[G]oto [I]mplementation")
        map("<leader>D", tb.lsp_type_definitions, "Type [D]efinition")
        map("<leader>ds", tb.lsp_document_symbols, "[D]ocument [S]ymbols")
        map("<leader>ws", tb.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

        -- Core LSP actions
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        map("K", vim.lsp.buf.hover, "Hover")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        -- Workspace management
        map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd")
        map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove")
        map("<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "[W]orkspace [L]ist")

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Document highlight
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_group,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd("LspDetach", {
            group = detach_group,
            buffer = event.buf,
            callback = function()
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = highlight_group, buffer = event.buf }
            end,
          })
        end

        -- Inlay hints toggle
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, "[T]oggle Inlay [H]ints")
        end

        -- Format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = event.buf,
          callback = function()
            vim.lsp.buf.format({ bufnr = event.buf })
          end,
        })
      end,
    })


    -- Capabilities Setup

    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities()
    )


    -- LSP Servers

    local servers = {
    --   lua_ls = {
    --     cmd = { "/usr/bin/lua-language-server" },
    --     settings = {
    --       Lua = {
    --         completion = { callSnippet = "Replace" },
    --         runtime = { version = "LuaJIT" },
    --         workspace = {
    --           checkThirdParty = false,
    --           library = vim.api.nvim_get_runtime_file("", true),
    --         },
    --         diagnostics = {
    --           globals = { "vim" },
    --           disable = { "missing-fields" },
    --         },
    --         format = { enable = false },
    --       },
    --     },
    --   },
    --
    --   pylsp = {
    --     settings = {
    --       pylsp = {
    --         plugins = {
    --           pyflakes = { enabled = false },
    --           pycodestyle = { enabled = false },
    --           autopep8 = { enabled = false },
    --           yapf = { enabled = false },
    --           mccabe = { enabled = false },
    --           pylsp_mypy = { enabled = false },
    --           pylsp_black = { enabled = false },
    --           pylsp_isort = { enabled = false },
    --         },
    --       },
    --     },
    --   },
    --
    --   bashls = {
    --     settings = {
    --       bashIde = {
    --         globPattern = "**/*@(.sh|.inc|.bash|.command)", -- files to watch
    --         completion = true,
    --         diagnostics = true,
    --         formatting = true, -- use shellcheck or shfmt
    --         filetypes = { "sh", "bash", "zsh" },
    --       },
    --     },
    --   },
    --
    --   ruff = {
    --     settings = {
    --       python = {
    --         linting = {
    --           enabled = true,
    --           flake8Enabled = false,
    --           pylintEnabled = false,
    --           ruffEnabled = true,
    --         },
    --         formatting = {
    --           provider = "ruff", -- auto-format on save
    --         },
    --       },
    --     },
    --   },
    --
    --   dockerls = {
    --     settings = {
    --       docker = {
    --         validate = true,       -- validate Dockerfile syntax
    --         completion = true,     -- auto-completion
    --       },
    --     },
    --   },
    --
    --   docker_compose_language_service = {
    --     settings = {
    --       yaml = {
    --         schemas = {
    --           ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
    --         },
    --         validate = true,
    --         completion = true,
    --       },
    --     },
    --   },
    --
    --   gopls = {
    --     settings = { gopls = { gofumpt = true, staticcheck = true } },
    --   },
    --   
    --   ts_ls = {
    --     settings = {
    --       javascript = { format = { enable = true } },
    --       typescript = { format = { enable = true } },
    --     },
    --   },
      
    }


    -- Mason Installer

    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, { "stylua" })

    require("mason-tool-installer").setup {
      ensure_installed = ensure_installed,
    }


    -- Register & Enable Servers

    for server, cfg in pairs(servers) do
      cfg.capabilities = capabilities
      vim.lsp.config(server, cfg)
      vim.lsp.enable(server)
    end
  end,
}

