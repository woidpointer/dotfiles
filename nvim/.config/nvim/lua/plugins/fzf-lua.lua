return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- or if using mini.icons/mini.nvim
		-- dependencies = { "echasnovski/mini.icons" },
		opts = {},
		keys = {
			{
				"<leader>fi",
				function()
					require("fzf-lua").files({ cwd = vim.fn.expand("%:p:h"), preview_opts = "down:50%" })
				end,
				desc = "Find files in interactive selected directory",
			},
			{
				"<leader>fM",
				function()
					local dirs = vim.fn.systemlist("fdfind --type d ")

					require("fzf-lua").fzf_exec(dirs, {
						prompt = "Select directories (Tab=multi-select)> ",
						fzf_opts = {
							["--multi"] = "",
							["--bind"] = "tab:toggle",
						},
						actions = {
							["default"] = function(selected)
								if selected and #selected > 0 then
									local search_paths = table.concat(selected, " ")
									require("fzf-lua").files({
										cmd = "fdfind --type f . " .. search_paths,
									})
								end
							end,
						},
					})
				end,
				desc = "Find files in multiple selected directories",
			},
			{
				"<leader>ff",
				function()
					require("fzf-lua").git_files({
						winopts = {
							preview = {
								layout = "horizontal",
								horizontal = "down:50%",
							},
						},
					})
				end,
				desc = "Find git Files in project directory",
			},
			{
				"<leader>fa",
				function()
					require("fzf-lua").files()
				end,
				desc = "Find all Files in project directory",
			},
			{
				"<leader>fg",
				function()
					require("fzf-lua").live_grep()
				end,
				desc = "Find by grepping in project directory",
			},
			{
				"<leader>fc",
				function()
					require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Find in neovim configuration",
			},
			{
				"<leader>fh",
				function()
					require("fzf-lua").helptags()
				end,
				desc = "[F]ind [H]elp",
			},
			{
				"<leader>fk",
				function()
					require("fzf-lua").keymaps()
				end,
				desc = "[F]ind [K]eymaps",
			},
			{
				"<leader>fb",
				function()
					require("fzf-lua").builtin()
				end,
				desc = "[F]ind [B]uiltin FZF",
			},
			{
				"<leader>fw",
				function()
					require("fzf-lua").grep_cword()
				end,
				desc = "[F]ind current [W]ord",
			},
			{
				"<leader>fW",
				function()
					require("fzf-lua").grep_cWORD()
				end,
				desc = "[F]ind current [W]ORD",
			},
			{
				"<leader>fd",
				function()
					require("fzf-lua").diagnostics_document()
				end,
				desc = "[F]ind [D]iagnostics",
			},
			{
				"<leader>fr",
				function()
					require("fzf-lua").resume()
				end,
				desc = "[F]ind [R]esume",
			},
			{
				"<leader>fo",
				function()
					require("fzf-lua").oldfiles()
				end,
				desc = "[F]ind [O]ld Files",
			},
			{
				"<leader><leader>",
				function()
					require("fzf-lua").buffers()
				end,
				desc = "Find existing buffers",
			},
			{
				"<leader>/",
				function()
					require("fzf-lua").lgrep_curbuf()
				end,
				desc = "[/] Live grep the current buffer",
			},
			{
				"<leader>sc",
				function()
					require("fzf-lua").spellcheck()
				end,
				desc = "Misspelled words in buffer",
			},
			{
				"<leader>sg",
				function()
					require("fzf-lua").spell_suggest()
				end,
				desc = "Spelling Suggesting",
			},
			{
				"gd",
				function()
					require("fzf-lua").lsp_definitions()
				end,
				desc = "Goto Definition",
			},
			{
				"gD",
				function()
					require("fzf-lua").lsp_declarations()
				end,
				desc = "Goto Definition",
			},
			{
				"<leader>lr",
				function()
					require("fzf-lua").lsp_references()
				end,
				desc = "List References",
			},
			{
				"gI",
				function()
					require("fzf-lua").lsp_implementations()
				end,
				desc = "Goto implementation",
			},
			{
				"<leader>D",
				function()
					require("fzf-lua").lsp_typedefs()
				end,
				desc = "LSP Type Definitions",
			},
			{
				"<leader>ca",
				function()
					require("fzf-lua").lsp_code_actions()
				end,
				desc = "Code Actions",
			},
			{
				"<leader>li",
				function()
					require("fzf-lua").lsp_incoming_calls()
				end,
				desc = "List Incoming calls",
			},
			{
				"<leader>lo",
				function()
					require("fzf-lua").lsp_outgoing_calls()
				end,
				desc = "List Outgoing calls",
			},
			{
				"<leader>co",
				function()
					require("fzf-lua").lsp_document_symbols({
						winopts = {
							preview = {
								layout = "horizontal",
								horizontal = "down:50%",
							},
						},
					})
				end,
				desc = "[c]ode [s]symbols",
			},
		},
		config = function()
			require("fzf-lua").setup({})
			require("fzf-lua").register_ui_select()
		end,
	},
}
