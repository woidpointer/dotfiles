return {
	{
		"michaelrommel/nvim-silicon",
		lazy = true,
		cmd = "Silicon",
		main = "nvim-silicon",
		opts = {
			-- Configuration here, or leave empty to use defaults
			line_offset = function(args)
				return args.line1
			end,
			background = "#ffffff",
			pad_horiz = 5,
			pad_vert = 5,
			-- no shadow
			shadow_color = "#ffffff",
		},
	},
}
