return {
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		enabled = false,
		keys = {
			{ "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle Neotree view" },
			{
				"<leader>np",
				"<cmd>NvimTreeResize +10<cr>",
				desc = "[Nvim]TreeResize [P]lus 10",
			},
			{
				"<leader>nm",
				"<cmd>NvimTreeResize -10<cr>",
				desc = "[Nvim]TreeResize [M]inus 10",
			},
		},
		config = function()
			require("nvim-tree").setup({
				filters = { dotfiles = false },
				disable_netrw = true,
				hijack_cursor = false,
				sync_root_with_cwd = true,
				update_focused_file = {
					enable = false,
					update_root = false,
				},
				view = {
					width = 40,
					preserve_window_proportions = true,
					relativenumber = true,
				},
				renderer = {
					highlight_git = true,
					indent_markers = { enable = true },
				},
			})
		end,
	},
}
