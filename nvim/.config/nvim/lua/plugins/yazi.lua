return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>e",
			"<cmd>Yazi<cr>",
			desc = "open Yazi in current directory",
		},
		{
			"<leader>E",
			"<cmd>Yazi cwd<cr>",
			desc = "open Yazi in cwd",
		},
	},
	opts = {
		open_for_directories = false,
		keymaps = {
			show_help = "<f1>",
			open_file_in_vertical_split = "<c-v>",
			open_file_in_horizontal_split = "<c-x>",
			open_file_in_tab = "<c-t>",
			grep_in_directory = "<c-s>",
			replace_in_directory = "<c-g>",
			cycle_open_buffers = "<tab>",
			send_to_quickfix_list = "<c-q>",
		},
		hooks = {
			yazi_opened = function(preselected_path, buffer_id, config)
				-- ESC zum Schließen
				vim.keymap.set("t", "<esc>", function()
					vim.cmd("close")
				end, { buffer = buffer_id, desc = "Schließe Yazi" })
			end,
		},
	},
}
