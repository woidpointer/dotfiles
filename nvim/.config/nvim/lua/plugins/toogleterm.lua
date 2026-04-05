return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<C-t>]],
				direction = "float",
				float_opts = {
					border = "curved",
					width = math.floor(vim.o.columns * 0.85),
					height = math.floor(vim.o.lines * 0.80),
				},
			})
		end,
	},
}
