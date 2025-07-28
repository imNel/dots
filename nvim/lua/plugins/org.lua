return {
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
	-- {
	-- 	"lukas-reineke/headlines.nvim",
	-- 	dependencies = "orgmode",
	-- 	opts = {},
	-- },
	{
		"akinsho/org-bullets.nvim",
		dependencies = "orgmode",
		opts = {
			concealcursor = true,
			symbols = {
				checkboxes = {
					half = { "-", "@org.checkbox.halfchecked" },
					done = { "", "@org.keyword.done" },
					todo = { " ", "@org.keyword.todo" },
				},
			},
		},
	},
}
