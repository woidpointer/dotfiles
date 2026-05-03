return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			auth_provider_url = "https://vector.ghe.com",
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<Tab>",
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},

			panel = {
				enabled = true,
				auto_refresh = false,
			},

			filetypes = {
				yaml = true,
				markdown = true,
				["*"] = true,
			},
		})
	end,
}
