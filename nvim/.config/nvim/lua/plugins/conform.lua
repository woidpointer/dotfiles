return {
	{
		"stevearc/conform.nvim",
		opts = {},

		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					-- Conform will run multiple formatters sequentially
					python = { "black", "ruff" },
					cpp = { "clang-format" },
					-- Use the "*" filetype to run formatters on all filetypes.
					["*"] = { "codespell" },
					-- Use the "_" filetype to run formatters on filetypes that don't
					-- have other formatters configured.
					["_"] = { "trim_whitespace" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					ruby = { "rubocop" },
				},
				format_after_save = {
					-- These options will be passed to conform.format()
					async = true,
					timeout_ms = 2500,
					lsp_format = "fallback",
				},
			})
		end,
	},
}
