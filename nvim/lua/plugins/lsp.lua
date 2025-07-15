return {
	{ "williamboman/mason.nvim", config = true },
	{
		"neovim/nvim-lspconfig",
		config = function()
			for _, server in ipairs({ "fennel_ls", "lua_ls", "tailwindcss", "ts_ls", "clangd", "kotlin_lsp", "eslint" }) do
				vim.lsp.enable(server)
			end
			return nil
		end,
	},
}
