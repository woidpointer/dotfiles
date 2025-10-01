return {

	-- CopilotChat lazy.nvim specification and extended configuration
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		-- If you want to pin a version, uncomment:
		-- version = "*",
		dependencies = {
			-- Core Copilot (provides auth + base agent)
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim" },
			-- Optional niceties:
			{ "nvim-treesitter/nvim-treesitter", optional = true },
			{ "nvim-telescope/telescope.nvim", optional = true },
			{ "nvim-lualine/lualine.nvim", optional = true },
			{ "nvim-tree/nvim-web-devicons", optional = true },
			{ "lewis6991/gitsigns.nvim", optional = true },
		},
		build = function()
			-- Builds tiktoken for better token counting (optional but recommended)
			local ok = pcall(vim.cmd, "CopilotChatBuild tiktoken")
			if not ok then
				vim.notify("CopilotChat: tiktoken build skipped (toolchain missing?)", vim.log.levels.WARN)
			end
		end,
		cmd = {
			"CopilotChat",
			"CopilotChatOpen",
			"CopilotChatClose",
			"CopilotChatToggle",
			"CopilotChatExplain",
			"CopilotChatOptimize",
			"CopilotChatTests",
			"CopilotChatReview",
			"CopilotChatFix",
			"CopilotChatCommit",
			"CopilotChatDocs",
			"CopilotChatModel",
			"CopilotChatStop",
		},
		event = "VeryLazy",
		opts = function()
			local select = require("CopilotChat.select")

			-- Central persona: how “I” (the assistant) will behave
			local system_prompt = table.concat({
				"You are an expert senior software engineer & architect assisting the user in Neovim.",
				"Guidelines:",
				"- Be concise, but give rationale when it prevents mistakes.",
				"- Offer step-by-step transformations for refactors.",
				"- Prefer incremental, diff-like answers when editing existing code.",
				"- NEVER fabricate APIs; if uncertain, state assumptions.",
				"- When asked for commit messages, use Conventional Commits.",
				"- Use markdown fenced code blocks with proper language tags.",
				"- If user supplies partial context, request clarifications only when critical.",
			}, "\n")

			return {
				debug = false,
				model = "gpt-4o", -- Adjust to any model CopilotChat supports
				-- Where to open the chat buffer
				window = {
					layout = "float", -- "float" | "vertical" | "horizontal" | "buffer"
					width = 0.45,
					height = 0.7,
					border = "rounded",
					title = " 󰚩 Copilot Chat ",
					footer = "Press <Esc> to leave insert / q to close",
				},
				mappings = {
					complete = { insert = "<C-Space>" },
					close = { normal = "q" },
					submit_prompt = { normal = "<CR>", insert = "<C-Enter>" },
					yank_last = { normal = "gy" },
					yank_all = { normal = "gY" },
					scroll_up = { normal = "<C-u>" },
					scroll_down = { normal = "<C-d>" },
				},
				system_prompt = system_prompt,
				show_help = true,
				context = "buffers", -- default context aggregator
				history_path = vim.fn.stdpath("data") .. "/copilot_chat_history.json",
				-- Custom prompt shortcuts
				prompts = {
					Explain = {
						prompt = "Explain the following code clearly and succinctly.",
						selection = select.visual_or_buffer,
					},
					-- Provide optimization suggestions with complexity/perf notes
					Optimize = {
						prompt = "Refactor / optimize the selected code. Explain trade-offs afterward.",
						selection = select.visual_or_buffer,
					},
					Tests = {
						prompt = "Generate unit tests for the selected code. Use existing test frameworks if identifiable.",
						selection = select.visual_or_buffer,
					},
					Review = {
						prompt = "Do a concise code review. List issues and improvements; group items by severity.",
						selection = select.visual_or_buffer,
					},
					Fix = {
						prompt = "The following code or error trace needs fixing. Provide corrected code and explanation.",
						selection = select.visual_or_buffer_or_line,
					},
					Docs = {
						prompt = "Write or improve inline documentation / docstrings for this code.",
						selection = select.visual_or_buffer,
					},
					Commit = {
						prompt = "Write a Conventional Commit message summarizing these staged changes with short scope + body.",
						selection = function()
							return select.gitdiff()
						end,
					},
					Translate = {
						prompt = "Translate this text to idiomatic English, preserving technical meaning.",
						selection = select.visual,
					},
					ExplainDiagnostics = {
						prompt = "Explain these diagnostics and propose fixes:",
						selection = function()
							return select.diagnostics()
						end,
					},
				},
				-- Token budgeting (adjust if hitting limits)
				max_context = 8192,
				max_output_tokens = 2048,
				-- Inline diffing style for edited responses
				diff = {
					autojump = true,
					staged = false,
					provider = "mini", -- or "builtin"
				},
				-- Which kinds of context providers are enabled
				context_providers = {
					buffers = { max = 5, strategy = "visible" },
					diagnostics = { severity = { "ERROR", "WARN" } },
					git = { include_unstaged = true },
				},
				-- Optional: highlight groups
				highlights = {
					user = "Title",
					assistant = "Function",
					system = "Comment",
				},
				-- Add ephemeral metadata to each request
				request_headers = function()
					return {
						["X-Editor"] = "Neovim",
						["X-Session-ID"] = vim.loop.os_getpid(),
					}
				end,
				-- Hooks
				on_open = function(bufnr)
					vim.bo[bufnr].filetype = "markdown"
				end,
				on_close = function() end,
			}
		end,
		config = function(_, opts)
			local chat = require("CopilotChat")
			chat.setup(opts)
			do
				local chat_ui = require("CopilotChat.ui.chat")
				local Chat = getmetatable(chat_ui) and chat_ui -- (abhängig von Implementierung)
				-- Falls Zugriff schwierig: einfach global nach dem Öffnen refokussieren:
				local orig_open = require("CopilotChat").open
				require("CopilotChat").open = function(cfg)
					orig_open(cfg)
					vim.schedule(function()
						-- suche Chat Fenster:
						for _, w in ipairs(vim.api.nvim_list_wins()) do
							local b = vim.api.nvim_win_get_buf(w)
							if vim.api.nvim_buf_get_name(b):match("copilot%-chat") then
								pcall(vim.api.nvim_set_current_win, w)
								break
							end
						end
					end)
				end
			end

			-- Telescope integration (if installed)
			pcall(function()
				require("telescope").load_extension("copilot_chat")
			end)

			-- Keymaps (leader c c style)
			local map = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { desc = desc })
			end

			map("n", "<leader>cc", function()
				chat.toggle()
			end, "Copilot Chat Toggle")
			map("n", "<leader>co", function()
				chat.open()
			end, "Copilot Chat Open")
			map("n", "<leader>cq", function()
				chat.close()
			end, "Copilot Chat Close")
			map("n", "<leader>cr", function()
				chat.reset()
			end, "Copilot Chat Reset")
			map({ "n", "v" }, "<leader>ce", function()
				chat.prompt("Explain")
			end, "Explain Code")
			map({ "n", "v" }, "<leader>ct", function()
				chat.prompt("Tests")
			end, "Generate Tests")
			map({ "n", "v" }, "<leader>cf", function()
				chat.prompt("Fix")
			end, "Fix / Debug")
			map({ "n", "v" }, "<leader>co", function()
				chat.prompt("Optimize")
			end, "Optimize / Refactor")
			map({ "n", "v" }, "<leader>cd", function()
				chat.prompt("Docs")
			end, "Docs / Comments")
			map({ "n", "v" }, "<leader>crv", function()
				chat.prompt("Review")
			end, "Code Review")
			map("n", "<leader>cm", function()
				chat.prompt("Commit")
			end, "Commit Message (Diff)")
			map({ "v" }, "<leader>cT", function()
				chat.prompt("Translate")
			end, "Translate Selection")
			map("n", "<leader>cD", function()
				chat.prompt("ExplainDiagnostics")
			end, "Explain Diagnostics")

			-- Quick ask (inline) for word under cursor:
			map("n", "<leader>c?", function()
				local symbol = vim.fn.expand("<cword>")
				chat.ask("Explain what " .. symbol .. " does in this context.")
			end, "Ask About Symbol")

			-- Example: integrate with lualine (if present)
			pcall(function()
				local comp = function()
					local state = chat.is_open() and "" or ""
					return state
				end
				local lualine = require("lualine")
				lualine.setup({
					sections = {
						lualine_c = { "filename", comp },
					},
				})
			end)
		end,
	},
}
