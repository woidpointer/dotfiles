return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>e",
			"<cmd>Yazi<cr>",
			desc = "open new Yazi instance in current directory",
		},
		{
			"<leader>E",
			"<cmd>Yazi cwd<cr>",
			desc = "open new Yazi instance in cwd",
		},
		{
			"<leader>-",
			"<cmd>Yazi toggle<cr>",
			desc = "toggle Yazi (resume last session)",
		},
	},
	opts = {
		open_for_directories = true,
		-- 👇 if you use `open_for_directories=true`, this is recommended
		init = function()
			-- mark netrw as loaded so it's not loaded at all.
			--
			-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
			vim.g.loaded_netrwPlugin = 1
		end,
		-- when yazi is closed with no file chosen, change the Neovim working
		-- directory to the directory that yazi was in before it was closed. Defaults
		-- to being off (`false`)
		change_neovim_cwd_on_close = false,

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
				vim.keymap.set("t", "<esc><esc>", function()
					vim.cmd("close")
				end, { buffer = buffer_id, desc = "Schließe Yazi" })
			end,
		},
	},
}
