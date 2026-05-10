local keys = require("config.picker")

return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- or if using mini.icons/mini.nvim
		-- dependencies = { "echasnovski/mini.icons" },
		keys = keys.fzf,
		opts = {
			grep = {
				-- debug = true,
				rg_glob = true,
				rg_glob_fn = function(q, _)
					local search_query, args = q:match("(.-)%s%-%-(.*)")
					return search_query, args
				end,
			},
		},
		config = function(_, opts)
			require("fzf-lua").setup(opts)
			require("fzf-lua").register_ui_select()
		end,
	},
}
