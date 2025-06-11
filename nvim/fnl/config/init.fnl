(set vim.g.mapleader " ")
(set vim.g.maplocalleader " ")
(set vim.opt.number true)
(set vim.opt.numberwidth 4)
(set vim.opt.relativenumber true)
(set vim.opt.tabstop 2)
(set vim.opt.softtabstop 2)
(set vim.opt.shiftwidth 2)
(set vim.opt.expandtab true)
(set vim.opt.smartindent true)
(set vim.opt.splitright true)
(set vim.opt.splitbelow true)
(set vim.opt.wrap false)
(set vim.opt.scrolloff 8)
(set vim.opt.termguicolors true)
(set vim.opt.conceallevel 0)
(set vim.opt.concealcursor "")

; Window Keybinds
(vim.keymap.set :n :<C-w>z
                (fn []
                  ((. (require :zen-mode) :toggle))))

; System Clipboard
(vim.keymap.set :n :<leader>y "\"+y")
(vim.keymap.set :v :<leader>y "\"+y")
(vim.keymap.set :n :<leader>Y "\"+Y")

; Void Clipboard
(vim.keymap.set :n :<leader>d "\"_d")
(vim.keymap.set :v :<leader>d "\"_d")

; Handy Keybinds
(vim.keymap.set :n :<ESC> "<cmd>:noh<CR><ESC>")
(vim.keymap.set :v :J ":m '>+1<CR>gv=gv")
(vim.keymap.set :v :K ":m '<-2<CR>gv=gv")
(vim.keymap.set :n :J "mzJ`z")
(vim.keymap.set :n :H "^")
(vim.keymap.set :n :L "$")

; Keeping stuff centred
(vim.keymap.set :n :<C-u> :<C-u>zz)
(vim.keymap.set :n :<C-d> :<C-d>zz)
(vim.keymap.set :n :n :nzzzv)
(vim.keymap.set :n :N :Nzzzv)

; Telescope, LSP, Everything else tbh
(vim.keymap.set :n :<C-p>
                (fn []
                  ((. (require :telescope.builtin) :find_files))))

(vim.keymap.set :n :<C-space>
                (fn []
                  ((. (require :telescope.builtin) :live_grep))))

(vim.keymap.set :n :<leader>b
                (fn []
                  ((. (require :telescope.builtin) :buffers))))

(vim.keymap.set :n :<leader>w
                (fn []
                  ((. (require :telescope.builtin) :diagnostics))))

(vim.keymap.set :n :<leader>e :<cmd>Ex<CR>)
(vim.keymap.set :n :<leader>u :<cmd>UndotreeToggle<CR><cmd>UndotreeFocus<CR>)
(vim.keymap.set :n :gd "<cmd>Telescope lsp_definitions<CR>")
(vim.keymap.set :n :gh (fn [] (vim.lsp.buf.hover {:silent true})))
(vim.keymap.set :n :gn (fn [] (vim.lsp.buf.rename)))
(vim.keymap.set :n :gr "<cmd>Telescope lsp_references<CR>")
(vim.keymap.set :n :gi "<cmd>Telescope lsp_implementations<CR>")
(vim.keymap.set :n :gl (fn [] (vim.diagnostic.open_float)))
(vim.keymap.set :n :gj
                (fn []
                  (vim.diagnostic.goto_next {:popup_opts {:focusable false}})))

(vim.keymap.set :n :gk
                (fn []
                  (vim.diagnostic.goto_prev {:popup_opts {:focusable false}})))

(vim.keymap.set :n :<leader>f
                (fn []
                  ((. (require :conform) :format))))

(vim.keymap.set :n :<leader>m "<cmd>Telescope monorepo<CR>")
(vim.keymap.set :n :<leader>a
                (fn []
                  ((. (require :monorepo) :toggle_project))))
