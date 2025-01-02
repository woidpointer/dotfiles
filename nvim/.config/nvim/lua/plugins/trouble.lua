return {
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>d",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "[D]iagnostic",
      },
      {
        "<leader>db",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "[D]iagnostic Buffer Diagnostics",
      },
      {
        "<leader>ds",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "[D]iagnostic Symbols",
      },
      {
        "<leader>dl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "[D]iagnostic LSP (Definitions / references / ... )",
      },
      {
        "<leader>dL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "[D]iagnostic Location List",
      },
      {
        "<leader>df",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "[D]iagnostic quick[f]ix List",
      },
    },
  },
}
