return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",
	opts = {
		ensure_installed = { "lua", "fennel", "typescript", "tsx", "c" },
		highlight = { enable = true },
		indent = { enable = true },
	},
}
