return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },

		settings = {
			save_on_toggle = false,
			sync_on_ui_close = false,
			-- key = function()
			--  return vim.loop.cwd()
			-- end,
		},

		config = function()
			local harpoon = require("harpoon")
			harpoon:setup({})

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end)

			-- ATTETION: Keymap for list is moved to picker.lua
			-- vim.keymap.set("n", "<leader>hl", function()
			-- 	harpoon.ui:toggle_quick_menu(harpoon:list())
			-- end)
		end,
	},
}
