return {
  -- add themes
  { "ellisonleao/gruvbox.nvim" },
  { "lunarvim/darkplus.nvim",
    lazy = false,
    priority = 1000,  -- load before everything else
    config = function()
      vim.cmd("colorscheme darkplus")
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "darkplus",
    },
  },
}
