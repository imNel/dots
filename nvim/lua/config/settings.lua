local o = vim.opt
local g = vim.g

-- Leader Key
g.mapleader = " "
g.maplocalleader = " "

-- Line Numbers
o.number = true
o.numberwidth = 4
o.relativenumber = true

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
