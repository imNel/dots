return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"nvim-orgmode/orgmode",
		event = "VeryLazy",
		main = "orgmode",
		opts = {
			org_agenda_files = "~/org/**/*",
			org_default_notes_file = "~/org/refile.org",
			org_startup_indented = true,
		},
	},
	{
		"lukas-reineke/headlines.nvim",
		dependencies = "orgmode",
    opts = {}
	},
}
