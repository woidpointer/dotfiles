return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				--[[
        -- Add here additional tools to be installed
        --]]
				ensure_installed = {
					"lua_ls",
					"clangd",
					"rubocop",
					"cmake",
					"black",
					"ruff",
					"clang-format",
					"stylua",
					"codespell",
					"jsonlint",
					"mypy",
					"hadolint",
					"markdownlint",
					"prettier",
					"yamllint",
					"cpptools",
				},
			})
		end,
	},
}
