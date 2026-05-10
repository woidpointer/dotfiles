local M = {}

M.snacks = {
	{
		"<leader>ff",
		function()
			Snacks.picker.git_files({ show_untracked = true })
		end,
		desc = "Find git files in project directory",
	},
	{
		"<leader>fg",
		function()
			Snacks.picker.grep({
				layout = {
					-- preset = "default",
				},
			})
		end,
		desc = "Find by grep in project directory",
	},
	{
		"<leader>fa",
		function()
			Snacks.picker.files()
		end,
		desc = "Find all files in project directory",
	},
	{
		"<leader>fi",
		function()
			Snacks.picker.files({ cwd = vim.fn.expand("%:p:h") })
		end,
		desc = "Find files in current file's directory",
	},
	{
		"<leader>se",
		function()
			Snacks.picker.icons()
		end,
		desc = "Icons/Emojis",
	},
	{
		"<leader>fgd",
		function()
			Snacks.picker.git_diff()
		end,
		desc = "Find in Git Diff to head",
	},
}

M.fzf = {
	{
		"<leader>fG",
		function()
			require("fzf-lua").fzf_live(
				"git rev-list --all | xargs git grep --line-number --column --color=always <query>",
				{
					fzf_opts = {
						["--delimiter"] = ":",
						["--preview-window"] = "nohidden,down,60%,border-top,+{3}+3/3,~3",
					},
					preview = "git show {1}:{2} | "
						.. "bat --style=default --color=always --file-name={2} --highlight-line={3}",
				}
			)
		end,
		desc = "Live git grep (entire history)",
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
		desc = "Goto Declaration",
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
		desc = "Goto Implementation",
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
					preview = { layout = "horizontal", horizontal = "down:50%" },
				},
			})
		end,
		desc = "[c]ode [s]symbols",
	},
	{
		"<leader>fm",
		function()
			require("fzf-lua").marks()
		end,
		desc = "[f]ind [m]arks",
	},
}

return M
