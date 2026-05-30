return {
	{
		"jbyuki/venn.nvim",
		lazy = false,
		keys = {
			{
				"<leader>v",
				function()
					local venn_enabled = vim.inspect(vim.b.venn_enabled)
					if venn_enabled == "nil" then
						vim.b.venn_enabled = true
						vim.cmd([[setlocal ve=all]])
						-- Linien zeichnen mit HJKL
						vim.keymap.set("n", "J", "<C-v>j:VBox<CR>", { noremap = true, buffer = true })
						vim.keymap.set("n", "K", "<C-v>k:VBox<CR>", { noremap = true, buffer = true })
						vim.keymap.set("n", "L", "<C-v>l:VBox<CR>", { noremap = true, buffer = true })
						vim.keymap.set("n", "H", "<C-v>h:VBox<CR>", { noremap = true, buffer = true })
						-- Box um Visual-Block-Selektion zeichnen
						vim.keymap.set("v", "f", ":VBox<CR>", { noremap = true, buffer = true })
						vim.notify("Venn mode ON", vim.log.levels.INFO)
					else
						vim.cmd([[setlocal ve=]])
						vim.keymap.del("n", "J", { buffer = true })
						vim.keymap.del("n", "K", { buffer = true })
						vim.keymap.del("n", "L", { buffer = true })
						vim.keymap.del("n", "H", { buffer = true })
						vim.keymap.del("v", "f", { buffer = true })
						vim.b.venn_enabled = nil
						vim.notify("Venn mode OFF", vim.log.levels.INFO)
					end
				end,
				desc = "Toggle Venn diagram mode",
			},
		},
	},
}
