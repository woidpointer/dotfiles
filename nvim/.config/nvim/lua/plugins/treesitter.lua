return {
	{
		"nvim-treesitter/nvim-treesitter",
		-- enabled = false,
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = {
					"c",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"cpp",
					"ruby",
					"markdown",
					"rst",
					"python",
					"xml",
					"json",
					"gitcommit",
					"gitignore",
					"dockerfile",
					"yaml",
				},
				auto_install = true,
				highlight = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<Leader>ss",
						node_incremental = "<Leader>si",
						scope_incremental = "<Leader>sc",
						node_decremental = "<Leader>sd",
					},
				},
			})
		end,
	},
}
