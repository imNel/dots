local o = vim.opt
local g = vim.g

-- Leader Key
g.mapleader = " "
g.maplocalleader = " "

-- Line Numbers
o.number = true
o.numberwidth = 4
o.relativenumber = true

-- Netrw
g.netrw_keepdir = 1
g.netrw_banner = 0
g.netrw_localcopydircmd = "cp -r"

-- Indentation
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

-- Window behaviour
o.splitright = true
o.splitbelow = true

-- Others
o.wrap = false
o.scrolloff = 8
o.termguicolors = true
o.conceallevel = 0
o.concealcursor = ""

-- Theme
vim.cmd.colorscheme("gruvbox-material")

-- Comments
require('kommentary.config').configure_language('default', {
  single_line_comment_string = 'auto',
  multi_line_comment_strings = 'auto',
})

-- Telescope
require("telescope").setup({
	defaults = {
		selection_strategy = "reset",
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		path_display = { "truncate" },
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.5,
			},
			width = 0.9,
			height = 0.9,
			preview_cutoff = 80,
		},
	},
	pickers = {
		find_files = {
			find_command = { "fd", "--type", "f", "-H", "-E", ".git" },
		},
	},
})

-- Treesitter
require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

-- LSP
local servers = {
	-- pyright = {},
	rust_analyzer = {},
	tsserver = {},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
  nil_ls = {},
}

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = vim.tbl_keys(servers),
})
-- require("neodev").setup()
require("fidget").setup({}) -- Notifications

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

require("mason-lspconfig").setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = nil,
			settings = servers[server_name],
			filetypes = (servers[server_name] or {}).filetypes,
		})
	end,
})

-- Sonarlint
require("sonarlint").setup({
	server = {
		cmd = {
			"sonarlint-language-server",
			-- Ensure that sonarlint-language-server uses stdio channel
			"-stdio",
			"-analyzers",
			-- paths to the analyzers you need, using those for python and java in this example
			vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
			vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarhtml.jar"),
		},
	},
	filetypes = {
		"typescript",
		"typescriptreact",
	},
})

-- Completion
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup()

-- Copilot (Disable suggestions, then add to cmp)
-- see `:Copilot`
-- require("copilot").setup({
-- 	suggestion = { enabled = false },
-- 	panel = { enabled = false },
-- })
-- require("copilot_cmp").setup()
require("supermaven-nvim").setup({})

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	}),
	sources = {
		{ name = "copilot", group_index = 2 },
		{ name = "nvim_lua" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
	},
})

-- cmp on command
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "cmdline" },
	}),
})

-- Formatting
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		scss = { "prettier" },
		css = { "prettier" },
		java = { "google-java-format" },
    nix = { "nixfmt" },
	},
	-- format_on_save = {
	-- 	-- These options will be passed to conform.format()
	-- 	timeout_ms = 500,
	-- 	lsp_fallback = true,
	-- },
})

-- Diagnostic settings
vim.diagnostic.config({
	underline = true,
	virtual_text = false,
	signs = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		style = "minimal",
		source = false,
	},
})

require("ibl").setup({ scope = { enabled = false }, indent = { char = "┆" } })
require("monorepo").setup()
require("colorizer").setup({})
