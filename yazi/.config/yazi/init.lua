require("yamb"):setup({
	-- feste Bookmarks die immer da sind:
	bookmarks = {
		{ tag = "Home", path = os.getenv("HOME") .. "/", key = "h" },
		{ tag = "Config", path = os.getenv("HOME") .. "/.config/", key = "c" },
		{ tag = "Downloads", path = os.getenv("HOME") .. "/Downloads/", key = "d" },
		{ tag = "dev", path = os.getenv("HOME") .. "/develop/", key = "d" },
	},
	cli = "fzf",
	jump_notify = false,
	-- Bookmarks werden hier gespeichert:
	path = os.getenv("HOME") .. "/.local/state/yazi/bookmark",
})
