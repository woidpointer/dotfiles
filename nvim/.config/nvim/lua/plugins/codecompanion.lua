local work_mode = os.getenv("WORK_MODE")
local default_adapter

if work_mode then
	default_adapter = "copilot_v"
else
	default_adapter = "ollama"
end

return {
	"olimorris/codecompanion.nvim",
	lazy = false,
	priority = 100,
	config = function(_, opts)
		require("codecompanion").setup(opts)

		-- Set up keybindings after plugin loads
		vim.keymap.set("n", "<leader>ct", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle CodeCompanion Chat" })
		vim.keymap.set("n", "<leader>cs", function()
			local adapters = { "ollama", "copilot_v" }
			local config = require("codecompanion.config")
			local current = config.config.interactions.chat.adapter or "copilot_v"

			vim.ui.select(adapters, {
				prompt = "Select CodeCompanion Adapter:",
				format_item = function(item)
					local marker = current == item and " (current)" or ""
					if item == "copilot_v" then
						return "Copilot (Claude Sonnet 4.5)" .. marker
					else
						return "Ollama (gpt-oss:20b-32k)" .. marker
					end
				end,
			}, function(choice)
				if choice then
					-- Update all interaction types to use the selected adapter
					config.config.interactions.chat.adapter = choice
					config.config.interactions.inline.adapter = choice
					config.config.interactions.cmd.adapter = choice
					config.config.interactions.agent.adapter = choice

					local display_name = choice == "copilot_v" and "Copilot (Claude Sonnet 4.5)"
						or "Ollama (gpt-oss:20b-32k)"

					vim.notify("CodeCompanion adapter switched to: " .. display_name, vim.log.levels.INFO)
				end
			end)
		end, { desc = "Switch CodeCompanion Adapter" })
	end,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/mcphub.nvim",
		{
			"OXY2DEV/markview.nvim",
			lazy = false,
			event = "VeryLazy",
			opts = {
				preview = {
					filetypes = { "markdown", "codecompanion" },
					ignore_buftypes = {},
					enable = true, -- disable preview as default
				},
			},
		},
		{
			"HakonHarnes/img-clip.nvim",
			opts = {
				filetypes = {
					codecompanion = {
						prompt_for_file_name = false,
						template = "[Image]($FILE_PATH)",
						use_absolute_path = true,
					},
				},
			},
		},
	},
	opts = {
		-- Adapter is set based on WORK_MODE environment variable
		interactions = {
			chat = {
				adapter = default_adapter,
				model = "gpt-oss:20b-32k:latest",
			},
			inline = {
				adapter = default_adapter,
				model = "gpt-oss:20b-32k:latest",
			},
			cmd = {
				adapter = default_adapter,
				model = "gpt-oss:20b-32k:latest",
			},
			agent = {
				adapter = default_adapter,
				model = "gpt-oss:20b-32k:latest",
			},
		},

		adapters = {
			http = {
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						schema = {
							model = {
								default = "gpt-oss-20b-32k:latest",
							},
							num_ctx = {
								default = 16384,
							},
							temperature = {
								default = 0.1,
							},
						},
					})
				end,
				copilot_v = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "claude-sonnet-4.5",
							},
							temperature = {
								default = 0.1,
							},
						},
					})
				end,
			},
		},

		display = {
			diff = {
				provider = "mini_diff",
			},
			chat = {
				window = {
					layout = "float",

					-- Float-spezifische Optionen
					relative = "win", --"editor", -- oder "cursor", "win"
					width = 0.8, -- 80% der Editor-Breite
					height = 0.8, -- 80% der Editor-Höhe

					-- Position
					row = 2, -- Vertikaler Offset
					col = 2, -- Horizontaler Offset

					-- Styling
					border = "rounded", -- "single", "double", "rounded", "solid", "shadow"
					zindex = 50, -- Layer-Priorität
				},

				show_settings = false,
			},
		},

		opts = {
			log_level = "INFO",
			send_code = true,
			use_default_actions = true,
			use_default_prompt_library = true,
		},

		prompt_library = {
			["Custom Code Review"] = {
				strategy = "chat",
				description = "Review the selected code for issues",
				opts = {
					mapping = "<LocalLeader>cr",
					modes = { "v" },
					slash_cmd = "review",
					auto_submit = true,
					user_prompt = true,
				},
				prompts = {
					{
						role = "system",
						content = "You are an experienced software developer. Review the following code for potential issues, bugs, and improvement opportunities.",
					},
					{
						role = "user",
						content = function(context)
							return "Please review this code:\n\n```"
								.. context.filetype
								.. "\n"
								.. context.selection
								.. "\n```"
						end,
					},
				},
			},
			["Explain Code"] = {
				strategy = "chat",
				description = "Explain the selected code",
				opts = {
					mapping = "<LocalLeader>ce",
					modes = { "v" },
					slash_cmd = "explain",
					auto_submit = true,
				},
				prompts = {
					{
						role = "system",
						content = "You are a helpful programming assistant. Explain code clearly and understandably.",
					},
					{
						role = "user",
						content = function(context)
							return "Please explain this code:\n\n```"
								.. context.filetype
								.. "\n"
								.. context.selection
								.. "\n```"
						end,
					},
				},
			},
		},

		extensions = {
			mcphub = {
				callback = "mcphub.extensions.codecompanion",
				opts = {
					make_tools = true,
					show_server_tools_in_chat = true,
					add_mcp_prefix_to_tool_names = false,
					show_result_in_chat = true,
					format_tool = nil,
					make_vars = true,
					make_slash_commands = true,
				},
			},
		},
	},
}
