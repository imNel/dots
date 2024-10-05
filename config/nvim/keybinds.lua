local set = vim.keymap.set

-- Window Keybinds
set("n", "<C-w>z", function()
	require("zen-mode").toggle()
end)
set("n", "<C-h>", "<C-w>h")
set("n", "<C-j>", "<C-w>j")
set("n", "<C-k>", "<C-w>k")
set("n", "<C-l>", "<C-w>l")

-- System Clipboard
set("n", "<leader>y", '"+y')
set("v", "<leader>y", '"+y')
set("n", "<leader>Y", '"+Y')
-- Void Clipboard
set("n", "<leader>d", '"_d')
set("v", "<leader>d", '"_d')

-- Handy Keybinds
set("n", "<ESC>", "<cmd>:noh<CR><ESC>") -- Esc unhighlights
set("v", "J", ":m '>+1<CR>gv=gv")
set("v", "K", ":m '<-2<CR>gv=gv")
set("n", "J", "mzJ`z")
set("n", "H", "^")
set("n", "L", "$")
-- Keepin stuff centred
set("n", "<C-u>", "<C-u>zz")
set("n", "<C-d>", "<C-d>zz")
set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")

-- Telescope
set("n", "<C-p>", function()
	require("telescope.builtin").find_files()
end)
set("n", "<C-space>", function()
	require("telescope.builtin").live_grep()
end)
set("n", "<leader>b", function()
	require("telescope.builtin").buffers()
end)
set("n", "<leader>w", function()
	require("telescope.builtin").diagnostics()
end)
set("n", "<leader>e", "<cmd>Ex<CR>")
set("n", "<leader>u", "<cmd>UndotreeToggle<CR><cmd>UndotreeFocus<CR>")

-- LSP Binds
set("n", "gd", "<cmd>Telescope lsp_definitions<CR>")
set("n", "gh", function()
	vim.lsp.buf.hover({ silent = true })
end)
set("n", "gn", function()
	vim.lsp.buf.rename()
end)
set("n", "gr", "<cmd>Telescope lsp_references<CR>")
set("n", "gi", "<cmd>Telescope lsp_implementations<CR>")
set("n", "gl", function()
	vim.diagnostic.open_float()
end)
set("n", "gj", function()
	vim.diagnostic.goto_next({ popup_opts = { focusable = false } })
end)
set("n", "gk", function()
	vim.diagnostic.goto_prev({ popup_opts = { focusable = false } })
end)
set("n", "<leader>f", function()
	require("conform").format()
end) --
set("n", "<leader>m", "<cmd>Telescope monorepo<CR>")
set("n", "<leader>a", function()
	require("monorepo").toggle_project()
end)
