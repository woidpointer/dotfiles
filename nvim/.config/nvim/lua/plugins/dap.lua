return {
	{
		"theHamsta/nvim-dap-virtual-text",
	},
	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
		},
		keys = {
			{
				"<leader>dT",
				function()
					require("dapui").toggle({})
				end,
				desc = "Dap UI",
			},
		},

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			require("nvim-dap-virtual-text").setup()

			dapui.setup()
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		dependencies = {
			"mason-org/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		opts = {
			handlers = {},
		},
	},
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			local fzf = require("fzf-lua")

			-- function to search executable within the build directory and lets the
			-- user fuzzy search on that list
			local function select_executable_fzf(callback)
				local bit = require("bit") -- for binary operations
				local scandir = require("plenary.scandir") -- for recursive search

				local cwd = vim.fn.getcwd()
				local build_dir = cwd .. "/build"

				local files = scandir.scan_dir(build_dir, {
					depth = nil, -- recursive: no limit
					add_dirs = false,
					hidden = false,
					only_files = true,
				})

				-- Filter only executables
				local executables = vim.tbl_filter(function(path)
					local stat = vim.loop.fs_stat(path)
					return stat and stat.type == "file" and bit.band(stat.mode, 0x49) ~= 0
				end, files)

				local display_to_full = {}
				local display_items = {}

				for _, full_path in ipairs(executables) do
					local rel_path = full_path:sub(#build_dir + 2) -- +2 für '/' nach build
					display_to_full[rel_path] = full_path
					table.insert(display_items, rel_path)
				end

				-- display FZF Picker with relative paths
				require("fzf-lua").fzf_exec(display_items, {
					prompt = "Executable > ",
					previewer = function(item)
						local full_path = display_to_full[item]
						return string.format("file %s", vim.fn.shellescape(full_path))
					end,
					fzf_opts = {
						["--ansi"] = "",
						["--preview-window"] = "right:60%",
					},
					actions = {
						["default"] = function(selected)
							if selected and selected[1] then
								local full = display_to_full[selected[1]]
								if full then
									callback(full)
								end
							end
						end,
					},
				})
			end

			-- Terminate Debug Process
			vim.keymap.set("n", "<leader>dX", function()
				require("dap").terminate()
				require("dapui").close() -- close ui
			end)
			vim.keymap.set("n", "<Leader>db", function()
				require("dap").toggle_breakpoint()
			end)

			vim.keymap.set("n", "<leader>dd", function()
				select_executable_fzf(function(exec)
					dap.run({
						type = "cppdbg",
						request = "launch",
						name = "Debug with selected executable",
						program = exec,
						cwd = vim.fn.getcwd(),
						stopOnEntry = false,
						args = { "--gtest_filter=Fixture.testcase" },
					})
				end)
			end, { desc = "FZF Debug-Start" })

			-- applied vim moves for debugging
			--   right => step into
			--   left  => step out
			--   down  => step over
			--   up    => restart

			vim.keymap.set("n", "<C-Right>", function()
				require("dap").step_into()
			end)
			vim.keymap.set("n", "<C-Left>", function()
				require("dap").step_out()
			end)
			vim.keymap.set("n", "<C-Down>", function()
				require("dap").step_over()
			end)
			vim.keymap.set("n", "<C-Up>", function()
				require("dap").restart()
			end)

			vim.keymap.set("n", "<Leader>dc", function()
				require("dap").run_to_cursor()
			end)
			-- vim.keymap.set("n", "<Leader>dl", function()
			--	require("dap").run_last()
			-- end)
			vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
				require("dap.ui.widgets").hover()
			end)
			vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
				require("dap.ui.widgets").preview()
			end)
			vim.keymap.set("n", "<Leader>df", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.frames)
			end)
			vim.keymap.set("n", "<Leader>ds", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes)
			end)
			vim.keymap.set("n", "<Leader>dt", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.threads)
			end)
		end,
	},
}
