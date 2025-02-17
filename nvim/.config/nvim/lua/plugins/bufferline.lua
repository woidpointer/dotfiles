return {
	{
		"akinsho/bufferline.nvim",
		keys = {
			{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
			{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
			{ "<leader>l", "<cmd>BufferLineCycleNext<cr>", desc = "Prev Buffer" },
			{ "<leader>h", "<cmd>BufferLineCyclePrev<cr>", desc = "Next Buffer" },
			{ "<leader>L", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
			{ "<leader>H", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
		},
		lazy = false,
		enabled = false,
		opts = {
			options = {
				mode = "buffers",
				style_preset = function()
					return require("bufferline").style_preset.default
				end,
				themable = true,
				buffer_close_icon = "󰅖",
				modified_icon = "● ",
				close_icon = " ",
				left_trunc_marker = " ",
				right_trunc_marker = " ",
				close_command = "bdelete! %d",
				diagnostics = "nvim_lsp",
				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						highlight = "Directory",
						text_align = "center",
					},
				},
				color_icons = true,
				get_element_icon = function(element)
					local icon, hl =
						require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
					return icon, hl
				end,
				show_buffer_icons = true,
				show_buffer_close_icons = true,
				show_close_icon = true,
				show_tab_indicators = true,
				show_duplicate_prefix = true,
				duplicates_across_groups = true,
				persist_buffer_sort = true,
				move_wraps_at_ends = false,
				-- can also be a table containing 2 custom separators
				-- [focused and unfocused]. eg: { '|', '|' }
				--separator_style = "slant", -- | "slope" | "thick" | "thin" | { 'any', 'any' },
				separator_style = "slant",
				enforce_regular_tabs = false,
				always_show_bufferline = true,
				auto_toggle_bufferline = true,
				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},
			},
		},
		dependencies = "nvim-tree/nvim-web-devicons",
	},
}

--[[
--]]
