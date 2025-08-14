vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.termguicolors = true
vim.opt.conceallevel = 2
-- vim.opt.concealcursor = ""

vim.keymap.set("n", "<C-w>z", function()
	return require("zen-mode").toggle()
end)
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')
vim.keymap.set("n", "<ESC>", "<cmd>:noh<CR><ESC>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

local function _2_()
	return require("telescope.builtin").find_files()
end
vim.keymap.set("n", "<C-p>", _2_)
local function _3_()
	return require("telescope.builtin").live_grep()
end
vim.keymap.set("n", "<C-space>", _3_)
local function _4_()
	return require("telescope.builtin").buffers()
end
vim.keymap.set("n", "<leader>b", _4_)
local function _5_()
	return require("telescope.builtin").diagnostics()
end
vim.keymap.set("n", "<leader>w", _5_)

vim.keymap.set("n", "<leader>e", "<cmd>Ex<CR>")
vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR><cmd>UndotreeFocus<CR>")
vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>")
local function _6_()
	return vim.lsp.buf.hover({ silent = true })
end
vim.keymap.set("n", "gh", _6_)
local function _7_()
	return vim.lsp.buf.rename()
end
vim.keymap.set("n", "gn", _7_)
vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>")
vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>")
local function _8_()
	return vim.diagnostic.open_float()
end
vim.keymap.set("n", "gl", _8_)
local function _9_()
	return vim.diagnostic.goto_next({ popup_opts = { focusable = false } })
end
vim.keymap.set("n", "gj", _9_)
local function _10_()
	return vim.diagnostic.goto_prev({ popup_opts = { focusable = false } })
end
vim.keymap.set("n", "gk", _10_)
vim.keymap.set("n", "<leader>f", function()
	return require("conform").format()
end)
vim.keymap.set("n", "<leader>m", "<cmd>Telescope monorepo<CR>")
local function _12_()
	return require("monorepo").toggle_project()
end
vim.keymap.set("n", "<leader>a", _12_)
vim.keymap.set("n", "<leader>sl", function()
	vim.cmd("source %")
end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "org",
  callback = function()
    vim.opt_local.textwidth = 80
  end,
})
