return {
	"olimorris/codecompanion.nvim",
	lazy = false,
	priority = 100,
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
					enable = false,
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
	config = function()
		-- GHE Copilot adapter
		-- Bypasses the copilot/init.lua handlers() bug that overwrites adapter.url
		local curl = require("plenary.curl")
		local files = require("codecompanion.utils.files")
		local log = require("codecompanion.utils.log")
		local openai = require("codecompanion.adapters.http.openai")

		local PROVIDER_URL = os.getenv("GHE_HOST")
		local _oauth_token = nil
		local _copilot_token = nil

		local function find_config_path()
			if os.getenv("CODECOMPANION_TOKEN_PATH") then
				return os.getenv("CODECOMPANION_TOKEN_PATH")
			end
			local path = vim.fs.normalize("$XDG_CONFIG_HOME")
			if path and vim.fn.isdirectory(path) > 0 then
				return path
			end
			path = vim.fs.normalize("~/.config")
			if vim.fn.isdirectory(path) > 0 then
				return path
			end
		end

		local function get_oauth_token()
			if _oauth_token then
				return _oauth_token
			end
			local token = os.getenv("GHE_COPILOT_TOKEN")
			if token then
				return token
			end
			local config_path = find_config_path()
			if not config_path then
				return nil
			end
			for _, file_path in ipairs({
				config_path .. "/github-copilot/apps.json",
				config_path .. "/github-copilot/hosts.json",
			}) do
				if vim.uv.fs_stat(file_path) then
					local ok, userdata = pcall(files.read, file_path)
					if ok then
						if vim.islist(userdata) then
							userdata = table.concat(userdata, " ")
						end
						local decoded = vim.json.decode(userdata)
						for key, value in pairs(decoded) do
							if key:find(PROVIDER_URL, 1, true) == 1 then
								_oauth_token = value.oauth_token
								return _oauth_token
							end
						end
					end
				end
			end
			return nil
		end

		local function get_copilot_token()
			if _copilot_token and _copilot_token.expires_at and _copilot_token.expires_at > os.time() then
				return _copilot_token
			end
			local oauth = get_oauth_token()
			if not oauth then
				log:error("GHE Adapter: No OAuth token found for %s", PROVIDER_URL)
				return nil
			end
			local TOKEN_URL = "https://api." .. PROVIDER_URL .. "/copilot_internal/v2/token"
			local ok, request = pcall(curl.get, TOKEN_URL, {
				headers = {
					Authorization = "Bearer " .. oauth,
					Accept = "application/json",
				},
			})
			if not ok then
				log:error("GHE Adapter: Token request failed: %s", request)
				return nil
			end
			local decoded_ok, decoded = pcall(vim.json.decode, request.body or "")
			if not decoded_ok or type(decoded) ~= "table" then
				log:error("GHE Adapter: Could not decode token response: %s", request.body)
				return nil
			end
			_copilot_token = decoded
			return _copilot_token
		end

		local version = vim.version()

		local copilot_ghe = {
			name = "copilot_ghe",
			formatted_name = "Copilot GHE",
			roles = { llm = "assistant", tool = "tool", user = "user" },
			opts = { stream = true, tools = true, vision = false },
			features = { text = true, tokens = true },
			url = PROVIDER_URL and ("https://copilot-api." .. PROVIDER_URL .. "/chat/completions") or "",
			env = {
				api_key = function()
					local t = get_copilot_token()
					return t and t.token or nil
				end,
			},
			headers = {
				Authorization = "Bearer ${api_key}",
				["Content-Type"] = "application/json",
				["Copilot-Integration-Id"] = "vscode-chat",
				["Editor-Version"] = "Neovim/" .. version.major .. "." .. version.minor .. "." .. version.patch,
			},
			handlers = {
				setup = function(self)
					local t = get_copilot_token()
					if not t or vim.tbl_isempty(t) then
						log:error("GHE Adapter: Could not get Copilot token")
						return false
					end
					if t.endpoints and t.endpoints.api then
						self.url = t.endpoints.api .. "/chat/completions"
					end
					self.parameters = self.parameters or {}
					self.parameters.stream = true
					return true
				end,
				form_parameters = function(self, params, messages)
					return openai.handlers.form_parameters(self, params, messages)
				end,
				form_messages = function(self, messages)
					return openai.handlers.form_messages(self, messages)
				end,
				form_tools = function(self, tools)
					return openai.handlers.form_tools(self, tools)
				end,
				chat_output = function(self, data, tools)
					return openai.handlers.chat_output(self, data, tools)
				end,
				inline_output = function(self, data, context)
					return openai.handlers.inline_output(self, data, context)
				end,
				tokens = function(self, data)
					return openai.handlers.tokens(self, data)
				end,
				tools = {
					format_tool_calls = function(self, tools)
						return openai.handlers.tools.format_tool_calls(self, tools)
					end,
					output_response = function(self, tool_call, output)
						return openai.handlers.tools.output_response(self, tool_call, output)
					end,
				},
				on_exit = function(self, data)
					_copilot_token = nil
					return openai.handlers.on_exit(self, data)
				end,
			},
			schema = {
				model = {
					order = 1,
					mapping = "parameters",
					type = "enum",
					desc = "The model to use.",
					default = "claude-sonnet-4.6",
					choices = {
						"claude-sonnet-4.6",
						"claude-sonnet-4.5",
						"claude-opus-4.6",
						"claude-opus-4.5",
						"claude-haiku-4.5",
						"gpt-4.1",
						"gpt-4o",
					},
				},
				temperature = {
					order = 2,
					mapping = "parameters",
					type = "number",
					default = 0.1,
				},
				max_tokens = {
					order = 3,
					mapping = "parameters",
					type = "integer",
					default = 16384,
				},
			},
		}

		local anthropic_schema = {
			model = {
				order = 1,
				mapping = "parameters",
				type = "enum",
				desc = "The Claude model to use.",
				default = "claude-sonnet-4-6",
				choices = {
					"claude-opus-4-8",
					"claude-sonnet-4-6",
					"claude-haiku-4-5-20251001",
				},
			},
			temperature = {
				order = 2,
				mapping = "parameters",
				type = "number",
				default = 0.1,
			},
			max_tokens = {
				order = 3,
				mapping = "parameters",
				type = "integer",
				default = 16384,
			},
		}

		-- Default: Copilot wenn GHE_HOST gesetzt, sonst Anthropic
		local default_adapter = PROVIDER_URL and "copilot_ghe" or "anthropic"

		local interactions = {
			chat = { adapter = default_adapter },
			inline = { adapter = default_adapter },
			cmd = { adapter = default_adapter },
			agent = { adapter = default_adapter },
		}

		require("codecompanion").setup({
			adapters = {
				http = {
					copilot_ghe = function()
						return copilot_ghe
					end,
				},
				anthropic = function()
					return require("codecompanion.adapters").extend("anthropic", {
						env = { api_key = "ANTHROPIC_API_KEY" },
						schema = anthropic_schema,
					})
				end,
			},

			interactions = interactions,

			display = {
				diff = { provider = "mini_diff" },
				chat = {
					window = {
						layout = "float",
						relative = "win",
						width = 0.8,
						height = 0.8,
						row = 2,
						col = 2,
						border = "rounded",
						zindex = 50,
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
		})

		vim.keymap.set("n", "<leader>ct", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle CodeCompanion Chat" })

		-- Kombinierter Adapter+Modell-Picker
		vim.keymap.set("n", "<leader>cm", function()
			local fzf = require("fzf-lua")

			local entries = {}
			if PROVIDER_URL then
				for _, m in ipairs(copilot_ghe.schema.model.choices) do
					table.insert(entries, "[Copilot] " .. m)
				end
			end
			for _, m in ipairs(anthropic_schema.model.choices) do
				table.insert(entries, "[Anthropic] " .. m)
			end

			local current_adapter = interactions.chat.adapter
			local current_model = current_adapter == "copilot_ghe"
				and copilot_ghe.schema.model.default
				or anthropic_schema.model.default
			local header = "active: "
				.. (current_adapter == "copilot_ghe" and "[Copilot]" or "[Anthropic]")
				.. " "
				.. current_model

			fzf.fzf_exec(entries, {
				prompt = "CodeCompanion> ",
				fzf_opts = { ["--header"] = header },
				actions = {
					["default"] = function(selected)
						if not selected or not selected[1] then
							return
						end
						local choice = selected[1]
						local adapter, model

						if choice:match("^%[Copilot%]") then
							adapter = "copilot_ghe"
							model = choice:match("^%[Copilot%] (.+)$")
							copilot_ghe.schema.model.default = model
						elseif choice:match("^%[Anthropic%]") then
							adapter = "anthropic"
							model = choice:match("^%[Anthropic%] (.+)$")
							anthropic_schema.model.default = model
						else
							return
						end

						interactions.chat.adapter = adapter
						interactions.inline.adapter = adapter
						interactions.cmd.adapter = adapter
						interactions.agent.adapter = adapter

						vim.notify("CodeCompanion: " .. choice, vim.log.levels.INFO)
					end,
				},
			})
		end, { desc = "CodeCompanion: select adapter & model" })
	end,
}
