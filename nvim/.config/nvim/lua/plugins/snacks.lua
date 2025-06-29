return {
	-- lazy.nvim
	{
		"folke/snacks.nvim",
		priority = 1000,
		enabled = true,
		lazy = false,
		---@type snacks.Config
		opts = {
			dashboard = {
				-- your dashboard configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
				enabled = true,
			},
		},
	},
}
