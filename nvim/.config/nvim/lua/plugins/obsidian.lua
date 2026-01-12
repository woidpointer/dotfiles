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

local work_mode = os.getenv("WORK_MODE")
local final_workspaces_list
if work_mode then
	print("Workmode")
	final_workspaces_list = {
		all_workspaces[2], -- "work"
		all_workspaces[1], -- "notes"
	}
else
	print("personal")
	final_workspaces_list = {
		all_workspaces[1], -- "notes"
		all_workspaces[2], -- "work"
	}
end

return {
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*",
		lazy = true,
		event = "VeryLazy",
		ft = "markdown",
		keys = {
			{
				"<leader>on",
				function()
					vim.ui.input({ prompt = "Note title: " }, function(title)
						if title then
							vim.cmd("Obsidian new_from_template " .. title .. " permanent-note")
						end
					end)
				end,
				desc = "New Obsidian note from template",
				mode = "n",
			},
			{
				"<leader>oN",
				function()
					vim.ui.input({ prompt = "Permanent note title: " }, function(title)
						if not title or title == "" then
							return
						end

						-- Pfad relative zum Vault
						local rel_path = "zettelkasten/" .. title

						-- fnameescape statt shellescape!
						local escaped_path = vim.fn.fnameescape(rel_path)

						vim.cmd("Obsidian new_from_template " .. escaped_path .. " permanent-note")
					end)
				end,
				desc = "New permanent note in zettelkasten",
				mode = "n",
			},
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
		opts = {
			ui = {
				enable = false,
			},
			legacy_commands = false,
			workspaces = final_workspaces_list,
			notes_subdir = "notes",
			new_notes_location = "notes_subdir",
			templates = {
				folder = "_templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
				-- Füge custom substitutions hinzu
				substitutions = {
					-- {{title}} wird durch den Original-Titel ersetzt (nicht kebab-case)
					title = function()
						return vim.g.obsidian_note_title or "Untitled"
					end,
				},
			},
			note_id_func = function(title)
				-- Speichere den Original-Titel in einer globalen Variable
				vim.g.obsidian_note_title = title

				if title ~= nil and title ~= "" then
					-- Konvertiere Title in kebab-case für den Dateinamen
					return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					-- Falls kein Title: Timestamp + 4-stellige Zufallszahl
					vim.g.obsidian_note_title = nil
					local suffix = ""
					for _ = 1, 4 do
						suffix = suffix .. tostring(math.random(0, 9))
					end
					return tostring(os.time()) .. "-" .. suffix
				end
			end,
			frontmatter = {
				enabled = true,
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
