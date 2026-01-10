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
		"obsidian-nvim/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		event = "VeryLazy",
		ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		-- event = {
		--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
		--   -- refer to `:h file-pattern` for more examples
		--   "BufReadPre path/to/my-vault/*.md",
		--   "BufNewFile path/to/my-vault/*.md",
		-- },
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",

			-- see below for full list of optional dependencies 👇
		},
		keys = {
			{ "<leader>on", "<cmd>Obsidian new<cr>", desc = "New Obsidian note", mode = "n" },
			{ "<leader>oo", "<cmd>Obsidian search<cr>", desc = "Search Obsidian notes", mode = "n" },
			{ "<leader>os", "<cmd>Obsidian quick_switch<cr>", desc = "Quick Switch", mode = "n" },
			{ "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Show backlinks", mode = "n" },
			{ "<leader>ot", "<cmd>Obsidian template<cr>", desc = "Insert template", mode = "n" },
			{ "<leader>op", "<cmd>Obsidian paste_img<cr>", desc = "Paste image from clipboard", mode = "n" },
			{
				"<leader>ok",
				":!mv '%:p' ~/.vaults/geistesblitze/zettelkasten<cr>:bd<cr>",
				desc = "[O]bsidian O[K]",
				mode = "n",
			},
			{ "<leader>odd", ":!rm '%:p'<cr>:bd<cr>", desc = "[O]bsidian [d]elete", mode = "n" },
		},
		---@module 'obsidian'
		---@type obsidian.config
		opts = {
			legacy_commands = false,
			workspaces = final_workspaces_list,
			notes_subdir = "notes",

			templates = {
				folder = "_templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
			},

			frontmatter = {
				func = function(note)
					local out = {
						id = note.id,
						aliases = note.aliases,
						tags = note.tags,
						created = os.date("%Y-%m-%d %H:%M"),
					}

					if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
						for k, v in pairs(note.metadata) do
							out[k] = v
						end
					end

					return out
				end,
			},

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

			completion = {
				nvim_cmp = false,
				blink = true,
				min_chars = 0,
			},
			picker = {
				name = "fzf-lua",
			},
		},
	},
}
