return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdateSync",
		config = function()
			-- Parsers installieren (synchron beim ersten Start)
			require("nvim-treesitter")
				.install({
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
				})
				:wait(300000) -- max 5 Minuten warten

			-- Highlighting enabled (optional, per FileType)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "lua", "python", "yaml", "markdown", "vim" }, -- define Sprachen
				callback = function()
					vim.treesitter.start()
				end,
			})

			-- Incremental selection wie vorher
			-- (Keymaps bleiben gleich, keine setup() nötig)
		end,
	},
}
