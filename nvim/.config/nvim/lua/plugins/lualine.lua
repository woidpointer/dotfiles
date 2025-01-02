return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          disabled_filetypes = { "NvimTree" },
        },
      })
    end,

    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
