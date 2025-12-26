return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "main", -- Try main branch for latest features
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		cmd = { "Neotree" },
		enabled = false,
		keys = {
			{ "<C-n>", "<cmd>Neotree toggle<cr>", desc = "Toggle Neotree view" },
			{ "<C-s>", "<cmd>Neotree toggle buffers<cr>", desc = "Toggle Neotree buffers" },
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = false,
				popup_border_style = "rounded",
				enable_git_status = true,
				enable_diagnostics = false,
				sort_case_insensitive = false,
				event_handlers = {
					{
						event = "neo_tree_window_after_open",
						handler = function(args)
							if args.position == "float" then
								vim.cmd("setlocal relativenumber")
								vim.cmd("setlocal number")
							end
						end,
					},
				},
				default_component_configs = {
					container = {
						enable_character_fade = true,
					},
					indent = {
						indent_size = 2,
						padding = 1,
						with_markers = true,
						indent_marker = "│",
						last_indent_marker = "└",
						highlight = "NeoTreeIndentMarker",
					},
					icon = {
						folder_closed = "",
						folder_open = "",
						folder_empty = "󰜌",
						default = "*",
						highlight = "NeoTreeFileIcon",
					},
					modified = {
						symbol = "[+]",
						highlight = "NeoTreeModified",
					},
					name = {
						trailing_slash = false,
						use_git_status_colors = true,
						highlight = "NeoTreeFileName",
						-- Remove truncation - we want to see full filenames
						-- max_length = 45,
					},
					git_status = {
						symbols = {
							added = "✚",
							modified = "",
							deleted = "✖",
							renamed = "󰁕",
							untracked = "",
							ignored = "",
							unstaged = "󰄱",
							staged = "",
							conflict = "",
						},
					},
				},
				window = {
					position = "float",
					width = 50, -- Use static number instead of function
					height = 25, -- Use static number instead of function
					popup = {
						position = "50%", -- Center both horizontally and vertically
						size = {
							width = "60%", -- Updated to 80% width
							height = "60%", -- Updated to 90% height
						},
					},
					mapping_options = {
						noremap = true,
						nowait = true,
					},
					mappings = {
						["<space>"] = "toggle_node",
						["<cr>"] = "open",
						["<esc>"] = "close_window",
						["P"] = { "toggle_preview", config = { use_float = true } },
						["l"] = "focus_preview",
						["S"] = "open_split",
						["s"] = "open_vsplit",
						["t"] = "open_tabnew",
						["w"] = "open_with_window_picker",
						["C"] = "close_node",
						["z"] = "close_all_nodes",
						["a"] = {
							"add",
							config = {
								show_path = "none",
							},
						},
						["A"] = "add_directory",
						["d"] = "delete",
						["r"] = "rename",
						["x"] = "cut_to_clipboard",
						["p"] = "paste_from_clipboard",
						["c"] = "copy",
						["m"] = "move",
						["q"] = "close_window",
						["R"] = "refresh",
						["?"] = "show_help",
						["<"] = "prev_source",
						[">"] = "next_source",
						["yf"] = {
							function(state) -- filename only
								local node = state.tree:get_node()
								local filename = vim.fn.fnamemodify(node.path, ":t")
								vim.fn.setreg("+", filename)
								print("Copied filename: " .. filename)
							end,
							desc = "Copy filename to clipboard",
						},
						["ya"] = {
							function(state) -- absolute path
								local node = state.tree:get_node()
								vim.fn.setreg("+", node.path)
								print("Copied absolute path: " .. node.path)
							end,
							desc = "Copy absolute filename to clipboard",
						},
						["yr"] = {
							function(state)
								local node = state.tree:get_node()
								local relative_path = vim.fn.fnamemodify(node.path, ":~:.")
								vim.fn.setreg("+", relative_path)
								print("Copied: " .. relative_path)
							end,
							desc = "Copy relative filename to clipboard",
						},
					},
				},
				nesting_rules = {},
				filesystem = {
					filtered_items = {
						visible = true,
						hide_dotfiles = false,
						hide_gitignored = true,
						hide_hidden = true,
						hide_by_name = {},
						hide_by_pattern = {},
						always_show = {},
						never_show = {},
					},
					follow_current_file = {
						enabled = false,
						leave_dirs_open = false,
					},
					group_empty_dirs = false,
					hijack_netrw_behavior = "open_default",
					use_libuv_file_watcher = false,
					window = {
						mappings = {
							["<bs>"] = "navigate_up",
							["."] = "set_root",
							["H"] = "toggle_hidden",
							["/"] = "fuzzy_finder",
							["D"] = "fuzzy_finder_directory",
							["#"] = "fuzzy_sorter",
							["f"] = "filter_on_submit",
							["<c-x>"] = "clear_filter",
							["[g"] = "prev_git_modified",
							["]g"] = "next_git_modified",
						},
					},
				},
				buffers = {
					follow_current_file = {
						enabled = true,
						leave_dirs_open = false,
					},
					group_empty_dirs = true,
					show_unloaded = true,
					window = {
						mappings = {
							["bd"] = "buffer_delete",
							["<bs>"] = "navigate_up",
							["."] = "set_root",
						},
					},
				},
				git_status = {
					window = {
						position = "float",
						mappings = {
							["A"] = "git_add_all",
							["gu"] = "git_unstage_file",
							["ga"] = "git_add_file",
							["gr"] = "git_revert_file",
							["gc"] = "git_commit",
							["gp"] = "git_push",
							["gg"] = "git_commit_and_push",
						},
					},
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
				require("neo-tree.command").execute({
					action = "focus",
					source = "filesystem",
					position = "float",
					popup = {
						position = { col = "10%", row = "5%" }, -- Centered: (100-80)/2 = 10% for col, (100-90)/2 = 5% for row
						size = {
							width = "80%", -- Updated to 80% width
							height = "90%", -- Updated to 90% height
						},
					},
					reveal = true,
					reveal_file = reveal_file,
				})
			end, { desc = "Open neo-tree at current file or working directory" })
		end,
	},
}
