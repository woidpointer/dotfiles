local keys = require("config.picker")

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
				layout = {
					layout = {
						-- Set to "rounded", "single", "double", "solid", "none"
						border = "solid",
					},
				},
			},
			bufdelete = {
				enabled = true,
			},
		},
		config = function(_, opts)
			require("snacks").setup(opts)
			vim.defer_fn(function()
				vim.api.nvim_set_hl(0, "SnacksPickerBorder", { fg = "#FFFFFF" })
			end, 50)
		end,
		keys = vim.list_extend({
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
		}, keys.snacks),
	},
}
