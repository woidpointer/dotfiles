return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		local PROVIDER_URL = os.getenv("GHE_HOST")
		if not PROVIDER_URL then
			return
		end
		require("copilot").setup({
			auth_provider_url = PROVIDER_URL,
			suggestion = {
				enabled = false,
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
