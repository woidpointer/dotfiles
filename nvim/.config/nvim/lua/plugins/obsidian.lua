local all_workspaces = {
	{
		name = "notes",
		path = "~/.vaults/geistesblitze",
	},
	{
		name = "work",
		path = "~/.vaults/work",
	},
}

-- Check the environment variable is set in the work environment
local work_mode = os.getenv("WORK_MODE")

-- Set the order of workspaces depending on the flag above. The first
-- position in that list is always the default
local final_workspaces_list
if work_mode then
	print("Workmode")
	-- If the environment variable is set, prioritize the "work" vault.
	-- The plugin uses the *first* matching path in the list.
	final_workspaces_list = {
		all_workspaces[2], -- "personal"
		all_workspaces[1], -- "work"
	}
else
	print("personal")
	-- If the environment variable is NOT set, prioritize the "personal" vault.
	final_workspaces_list = {
		all_workspaces[1], -- "personal"
		all_workspaces[2], -- "work"
	}
end

return {
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = false,
		ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		-- event = {
		--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
		--   -- refer to `:h file-pattern` for more examples
		--   "BufReadPre path/to/my-vault/*.md",
		--   "BufNewFile path/to/my-vault/*.md",
		-- },

		-- cond will be evaluated when plugin is loaded
		cond = function()
			-- Check if at least one vault exists
			for _, workspace in ipairs(all_workspaces) do
				local path = vim.fn.expand(workspace.path)
				if vim.fn.isdirectory(path) == 1 then
					return true
				end
			end
			return false
		end,

		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",

			-- see below for full list of optional dependencies 👇
		},
		keys = {
			{ "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Obsidian note", mode = "n" },
			{ "<leader>oo", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian notes", mode = "n" },
			{ "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch", mode = "n" },
			{ "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show location list of backlinks", mode = "n" },
			{ "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Follow link under cursor", mode = "n" },
			{ "<leader>op", "<cmd>ObsidianPasteImg<cr>", desc = "Paste imate from clipboard under cursor", mode = "n" },
			{
				"<leader>ok",
				":!mv '%:p' ~/.vaults/geistesblitze/zettelkasten<cr>:bd<cr>",
				desc = "[O]bsidian O[K]",
				mode = "n",
			},
			{ "<leader>odd", ":!rm '%:p'<cr>:bd<cr>", desc = "[O]bsidian [d]elete", mode = "n" },
		},
		opts = {
			workspaces = final_workspaces_list,
			notes_subdir = "notes",

			-- see below for full list of options 👇
			--
			note_id_func = function(title)
				-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
				-- In this case a note with the title 'My new note' will be given an ID that looks
				-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
				local suffix = ""
				if title ~= nil then
					-- If title is given, transform it into valid file name.
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					-- If title is nil, just add 4 random uppercase letters to the suffix.
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end
				return tostring(os.time()) .. "-" .. suffix
			end,
		},
	},
}
