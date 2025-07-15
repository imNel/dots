return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = { pickers = { find_files = { find_command = { "fd", "--type", "f", "-H", "-E", ".git" } } } },
	tag = "0.1.8",
}
