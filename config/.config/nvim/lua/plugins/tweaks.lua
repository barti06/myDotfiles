return {
  -- STOP CLANGD FROM INSERTING HEADERS
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--header-insertion=never", -- stop automatic header insertion
            "--fallback-style=none", -- no formatting
            "--completion-style=detailed",
          },
        },
      },
      setup = {
        clangd = function(_, opts)
          -- use standard nvim api instead of LazyVim's internal utilities
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              if client and client.name == "clangd" then
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                -- disable formatting capabilities
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
                vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
              end
            end,
          })
          -- return false to tell LazyVim to continue with the standard lspconfig setup
          return false
        end,
      },
    },
  },
  -- STOP LAZYVIM'S AUTO-FORMATTER FOR C/C++
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = {},
        cpp = {},
        objc = {},
        objcpp = {},
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
    ensure_installed = {},
    automatic_installation = false,
    },
  },
}
