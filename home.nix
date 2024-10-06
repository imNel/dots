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
              rev = "aecec7090f1da456ad5683f5c6c3640c2a745dc1";
              hash = "sha256-dYsu16uNsbZzI7QhXV3QBkvJy+0MndfGwcb1zQi5ic0=";
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
            just
            fzf
            loc
            onefetch
            azure-cli
            vesktop
          ];
          programs = {
            kitty = {
              enable = true;
              font = {
                name = "Twilio Sans Mono";
                size = 16;
              };
              settings = {
                macos_titlebar_color = "#191724";
                window_padding_width = 4;
              };
              extraConfig = builtins.readFile ./config/kitty.conf;
            };
            git = {
              enable = true;
              userName = "Nel";
              userEmail = "46218259+imNel@users.noreply.github.com";
              delta = {
                enable = true;
                # tokyonight.enable = true;
              };
              aliases = {
                churn = "!git log --all -M -C --name-only --format='format:' -- | sort | grep -v '^$' | uniq -c | sort -nr | bat";
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
                colorbuddy-nvim
                rose-pine
              ];
            };
          };
        };
      # home-manager config specific to NixOS
      linux =
        { pkgs, ... }:
        {
          # xsession.enable = true;
          wayland.windowManager.sway = {
            enable = true;
            package = pkgs.swayfx;
            checkConfig = false; # https://github.com/nix-community/home-manager/issues/5379
            config = {
              modifier = "Mod4";
              terminal = "kitty";
              menu = "${pkgs.wmenu}/bin/wmenu-run";
              gaps = {
                inner = 4;
                outer = 4;
              };
              # This is specific for my home PC, will need to be made dynamic
              output = {
                HDMI-A-1 = {
                  scale = "1.0";
                  res = "3440x1440@100Hz";
                  pos = "0 0";
                };
                DP-1 = {
                  scale = "1.0";
                  res = "1920x1080@165Hz";
                  pos = "3440 360";
                };
              };
            };
            extraConfig = ''
              corner_radius 4
            '';
          };
        };
      # home-manager config specific to Darwin
      darwin = {
        # targets.darwin.search = "Bing";
      };
    };
  };
}
