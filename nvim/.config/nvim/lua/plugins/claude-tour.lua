return {
  "woidpointer/claude-tour.nvim",
  -- Load at startup: the :ClaudeTour* commands and require("claude_tour") from --remote-expr must always work.
  lazy = false,
  opts = {},
  keys = {
    { "ön", "<cmd>ClaudeTourNext<cr>", desc = "Next tour step" },
    { "öN", "<cmd>ClaudeTourPrev<cr>", desc = "Previous tour step" },
  },
}
