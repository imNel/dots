{ ... }:
{
  flake = {
    # All home-manager configurations are kept here.
    homeModules = {
      # Common home-manager configuration shared between Linux and macOS.
      common =
        { pkgs, ... }:
        let
          monorepo-nvim = pkgs.vimUtils.buildVimPlugin {
            name = "monorepo.nvim";
            src = pkgs.fetchFromGitHub {
              owner = "imNel";
              repo = "monorepo.nvim";
              rev = "256a302900d6af6e032f1f2bf4f2407bd4569fe8";
              hash = "sha256-thljxwZCPUxrhF6FbBhzxW0BkVK4OVmbIzNZocLnChs=";
            };
          };
          supermaven-nvim = pkgs.vimUtils.buildVimPlugin {
            name = "supermaven-nvim";
            src = pkgs.fetchFromGitHub {
              owner = "supermaven-inc";
              repo = "supermaven-nvim";
              rev = "7698b982ae96a5decca84219390e273bd428dc86";
              hash = "sha256-tzrWDjlBMB4r4bI78CXrsTqjgEaks3Lc7k+gYJUUx14=";
            };
          };
          sonarlint-nvim = pkgs.vimUtils.buildVimPlugin {
            name = "sonarlint.nvim";
            src = pkgs.fetchFromGitLab {
              owner = "schrieveslaach";
              repo = "sonarlint.nvim";
              rev = "818f5b932b25df2b6395b40e59d975070f517af7";
              hash = "sha256-gkqt4rsH9VOy4JOWmcc65z70qejkCCaB7iKXRwIKeAY=";
            };
          };
        in
        {
          home.packages = with pkgs; [
            fnm
            fzf
            loc
            onefetch
            azure-cli
          ];
          programs = {
            wezterm = {
              enable = true;
              extraConfig = builtins.readFile ./config/wezterm.lua;
            };
            git = {
              enable = true;
              userName = "Nel";
              userEmail = "46218259+imNel@users.noreply.github.com";
              delta = {
                enable = true;
                # tokyonight.enable = true;
              };
            };

            zsh = {
              enable = true;
              initExtra = builtins.readFile ./zshrc;
              oh-my-zsh = {
                enable = true;
                plugins = [ "git" ];
              };
              shellAliases = {
                lg = "lazygit";
                nvm = "echo You should use fnm instead of nvm";
                neofetch = "hyfetch";
                hpm = "pnpm hpm";
                h = "z huddler";
              };
            };

            eza = {
              enable = true;
              icons = true;
              git = true;
            };

            direnv.enable = true;
            starship.enable = true;
            zoxide.enable = true;
            lazygit.enable = true;
            fd.enable = true;
            ripgrep.enable = true;
            hyfetch.enable = true;
            gh.enable = true;
            bat.enable = true;
            neovim = {
              enable = true;
              defaultEditor = true;
              vimAlias = true;
              extraLuaConfig = builtins.concatStringsSep "\n" (
                builtins.map builtins.readFile [
                  ./config/nvim/settings.lua
                  ./config/nvim/keybinds.lua
                ]
              );
              plugins = with pkgs.vimPlugins; [
                nvim-treesitter.withAllGrammars
                nvim-lspconfig
                mason-nvim
                mason-lspconfig-nvim
                fidget-nvim
                nvim-cmp
                luasnip
                cmp_luasnip
                cmp-nvim-lsp
                cmp-path
                cmp-buffer
                cmp-nvim-lua
                cmp-cmdline
                friendly-snippets
                supermaven-nvim
                undotree
                telescope-nvim
                plenary-nvim
                kommentary
                conform-nvim
                indent-blankline-nvim
                sonarlint-nvim
                zen-mode-nvim
                monorepo-nvim
                gruvbox-material
                nvim-web-devicons
                nvim-colorizer-lua
              ];
            };
          };
        };
      # home-manager config specific to NixOS
      linux = {
        # xsession.enable = true;
      };
      # home-manager config specific to Darwin
      darwin = {
        # targets.darwin.search = "Bing";
      };
    };
  };
}
