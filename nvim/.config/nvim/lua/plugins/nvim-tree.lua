return {
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		enabled = true,
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

			vim.keymap.set("n", "<leader>loc", function()
				local reveal_file = vim.fn.expand("%:p")
				if reveal_file == "" then
					reveal_file = vim.fn.getcwd()
				else
					local f = io.open(reveal_file, "r")
					if f then
						f:close()
					else
						reveal_file = vim.fn.getcwd()
					end
				end

				require("nvim-tree.api").tree.open({
					find_file = true, -- Opens the tree and focuses on the file
					update_root = true, -- Updates the root directory to match the file's location
				})
			end, { desc = "Open nvim-tree at current file or working directory" })
		end,
	},
}
