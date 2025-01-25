return {
	{
		"echasnovski/mini.nvim",
		version = "*",
		config = function()
			require("mini.indentscope").setup()
			require("mini.move").setup({
				mappings = {
					-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
					left = "H",
					right = "L",
					down = "J",
					up = "K",

					-- Move current line in Normal mode
					line_left = "",
					line_right = "",
					line_down = "",
					line_up = "",
				},
			})
			require("mini.pairs").setup()
			require("mini.surround").setup()
		end,
	},
}
