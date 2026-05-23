return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = { "rafamadriz/friendly-snippets" },

	version = "1.*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			["<C-j>"] = { "show", "select_next", "fallback" },
			["<C-k>"] = { "show", "select_prev", "fallback" },
			["<C-e>"] = { "hide", "fallback" },
			["<up>"] = { "select_prev", "fallback" },
			["<down>"] = { "select_next", "fallback" },
			["<C-]>"] = { "show_documentation", "hide_documentation", "fallback" },
			["<C-u>"] = { "scroll_documentation_up", "fallback" },
			["<C-d>"] = { "scroll_documentation_down", "fallback" },
			["<C-f>"] = { "snippet_forward", "fallback" },
			["<C-b>"] = { "snippet_backward", "fallback" },
			["<CR>"] = { "select_and_accept", "fallback" },
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		signature = { enabled = true },

		completion = {
			documentation = { auto_show = false },
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			-- Für json5: path-Source deaktivieren (kollidiert mit cfu ref-Completion),
			-- stattdessen eigenen cfu-Source nutzen
			per_filetype = {
				json5 = { "cfu_ref", "snippets", "buffer" },
			},
			providers = {
				cfu_ref = {
					name = "cfu",
					module = "cfu_completion",
				},
			},
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
