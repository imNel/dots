[{1 :williamboman/mason.nvim :config true}
 {1 :neovim/nvim-lspconfig
  :config (fn []
            (each [_ server (ipairs [:fennel_ls :lua_ls :tailwindcss :ts_ls :clangd :kotlin_lsp])]
              (vim.lsp.enable server)))}]
