{self, inputs, ...}:
{
  flake = {
    # All home-manager configurations are kept here.
    homeModules = {
      # Common home-manager configuration shared between Linux and macOS.
      common = { pkgs, ... }: {
        home.packages = with pkgs; [ fnm fzf loc onefetch azure-cli ];
        programs = {
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
            # extraLuaConfig = builtins.readFile ./nvim.lua;
            # plugins = with pkgs.vimPlugins; [ 
            #   tokyonight-nvim
            #   telescope-nvim
            #   conform-nvim
            # ];
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
