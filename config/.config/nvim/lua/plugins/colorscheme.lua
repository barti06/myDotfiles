return {
  -- add themes
  { "ellisonleao/gruvbox.nvim" },
  {
    "lunarvim/darkplus.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "darkplus",
        callback = function()
          local black = { bg = "#000000" }
          -- set main background to black
          vim.api.nvim_set_hl(0, "Normal", black)
          vim.api.nvim_set_hl(0, "NormalNC", black)
          -- set ui elements to black
          vim.api.nvim_set_hl(0, "NormalFloat", black)
          vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#000000", fg = "#242424" })
          vim.api.nvim_set_hl(0, "LineNr", black)
          vim.api.nvim_set_hl(0, "SignColumn", black)

          -- set active cursor line to black
          vim.api.nvim_set_hl(0, "CursorLine", black)
          vim.api.nvim_set_hl(0, "CursorLineNC", black)
          vim.api.nvim_set_hl(0, "ColorColumn", black)
        end,
      })

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
