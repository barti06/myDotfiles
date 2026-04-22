return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        clangd = { mason = false },
        lua_ls = { mason = false },
        pyright = { mason = false },
        ts_ls = { mason = false },
        bashls = { mason = false },
        nixd = { mason = false },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
      },
      automatic_installation = false,
    },
  },
}
