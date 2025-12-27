return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/mcphub.nvim",
		{
			"OXY2DEV/markview.nvim",
			lazy = false,
			opts = {
				preview = {
					filetypes = { "markdown", "codecompanion" },
					ignore_buftypes = {},
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
		interactions = {
			chat = {
				adapter = "ollama",
				model = "gpt-oss:20b",
			},
			inline = {
				adapter = "ollama",
				model = "gpt-oss:20b",
			},
			cmd = {
				adapter = "ollama",
				model = "gpt-oss:20b",
			},
			agent = {
				adapter = "ollama",
				model = "gpt-oss:20b",
			},
		},

		adapters = {
			http = {
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						schema = {
							model = {
								default = "gpt-oss:20b",
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
			},
		},

		display = {
			diff = {
				provider = "mini_diff",
			},
			chat = {
				window = {
					layout = "vertical",
					width = 0.45,
					height = 0.8,
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
