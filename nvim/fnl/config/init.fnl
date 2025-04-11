(local o vim.opt)
(local g vim.g)
(set g.mapleader " ")
(set g.maplocalleader " ")
(set o.number true)
(set o.numberwidth 4)
(set o.relativenumber true)
(set o.tabstop 2)
(set o.softtabstop 2)
(set o.shiftwidth 2)
(set o.expandtab true)
(set o.smartindent true)
(set o.splitright true)
(set o.splitbelow true)
(set o.wrap false)
(set o.scrolloff 8)
(set o.termguicolors true)
(set o.conceallevel 0)
(set o.concealcursor "")

(local ___set___ vim.keymap.set)
(___set___ :n :<C-w>z
           (fn []
             ((. (require :zen-mode) :toggle))))

(___set___ :n :<leader>y "\"+y")
(___set___ :v :<leader>y "\"+y")
(___set___ :n :<leader>Y "\"+Y")
(___set___ :n :<leader>d "\"_d")
(___set___ :v :<leader>d "\"_d")
(___set___ :n :<ESC> "<cmd>:noh<CR><ESC>")
(___set___ :v :J ":m '>+1<CR>gv=gv")
(___set___ :v :K ":m '<-2<CR>gv=gv")
(___set___ :n :J "mzJ`z")
(___set___ :n :H "^")
(___set___ :n :L "$")
(___set___ :n :<C-u> :<C-u>zz)
(___set___ :n :<C-d> :<C-d>zz)
(___set___ :n :n :nzzzv)
(___set___ :n :N :Nzzzv)
(___set___ :n :<C-p>
           (fn []
             ((. (require :telescope.builtin) :find_files))))

(___set___ :n :<C-space>
           (fn []
             ((. (require :telescope.builtin) :live_grep))))

(___set___ :n :<leader>b
           (fn []
             ((. (require :telescope.builtin) :buffers))))

(___set___ :n :<leader>w
           (fn []
             ((. (require :telescope.builtin) :diagnostics))))

(___set___ :n :<leader>e :<cmd>Ex<CR>)
(___set___ :n :<leader>u :<cmd>UndotreeToggle<CR><cmd>UndotreeFocus<CR>)
(___set___ :n :gd "<cmd>Telescope lsp_definitions<CR>")
(___set___ :n :gh (fn [] (vim.lsp.buf.hover {:silent true})))
(___set___ :n :gn (fn [] (vim.lsp.buf.rename)))
(___set___ :n :gr "<cmd>Telescope lsp_references<CR>")
(___set___ :n :gi "<cmd>Telescope lsp_implementations<CR>")
(___set___ :n :gl (fn [] (vim.diagnostic.open_float)))
(___set___ :n :gj
           (fn []
             (vim.diagnostic.goto_next {:popup_opts {:focusable false}})))

(___set___ :n :gk
           (fn []
             (vim.diagnostic.goto_prev {:popup_opts {:focusable false}})))

(___set___ :n :<leader>f
           (fn []
             ((. (require :conform) :format))))

(___set___ :n :<leader>m "<cmd>Telescope monorepo<CR>")
(___set___ :n :<leader>a
           (fn []
             ((. (require :monorepo) :toggle_project))))
