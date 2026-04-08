return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		-- enabled = false,
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<C-t>]],
				direction = "float",
				float_opts = {
					border = "curved",
					width = math.floor(vim.o.columns * 0.85),
					height = math.floor(vim.o.lines * 0.80),
				},
			})

			-- Mapping um mit Esc in Normal Mode zu wechseln
			vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

			-- opencode Terminal
			local Terminal = require("toggleterm.terminal").Terminal

			local opencode = Terminal:new({
				cmd = "opencode",
				hidden = true,
				direction = "float",
				float_opts = {
					border = "curved",
					width = math.floor(vim.o.columns * 0.85),
					height = math.floor(vim.o.lines * 0.80),
				},
			})

			--vim.keymap.set("n", "<C-c>", function()
			vim.keymap.set("n", "<leader>oc", function()
				opencode:toggle()
			end, { noremap = true, silent = true })
			vim.keymap.set("t", "<leader>oc", function()
				opencode:toggle()
			end, { noremap = true, silent = true })

			-- nvim mit obsidian plugin Terminal
			local obsidian_nvim = Terminal:new({
				cmd = "nvim ~/.vaults/work/notes",
				hidden = true,
				direction = "float",
				float_opts = {
					border = "curved",
					width = math.floor(vim.o.columns * 0.85),
					height = math.floor(vim.o.lines * 0.80),
				},
			})

			vim.keymap.set("n", "<leader>to", function()
				obsidian_nvim:toggle()
			end, { noremap = true, silent = true, desc = "Toggle Obsidian Terminal" })
			vim.keymap.set("t", "<leader>to", function()
				obsidian_nvim:toggle()
			end, { noremap = true, silent = true, desc = "Toggle Obsidian Terminal" })
		end,
	},
}
