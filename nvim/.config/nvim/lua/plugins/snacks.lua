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
			lazygit = {
				enabled = true,
			},
			scratch = {
				enabled = true,
			},
			picker = {
				enabled = true,
			},
			bufdelete = {
				enabled = true,
			},
		},
		keys = {
			{
				"<leader>.",
				function()
					Snacks.scratch()
				end,
				desc = "Toggle Scratch Buffer",
			},
			{
				"<leader>S",
				function()
					Snacks.scratch.select()
				end,
				desc = "Select Scratch Buffer",
			},
			{
				"<leader>G",
				function()
					Snacks.lazygit.open()
				end,
				desc = "Open Lazygit",
			},
			{
				"<leader>se",
				function()
					Snacks.picker.icons()
				end,
				desc = "Icons/Emojis",
			},
		},
	},
}
