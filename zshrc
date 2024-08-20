# nix config path additions
export PATH=/etc/profiles/per-user/$USER/bin:/nix/var/nix/profiles/system/sw/bin:/usr/local/bin:$PATH

eval "$(fnm env --use-on-cd)"

# other stuff, probably need to remove later
export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS:$HOME/Library/pnpm:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.local/share/fnm:$HOME/.emacs.d/bin:$HOME/Clones/kotlin-language-server/server/build/install/server/bin"

export EDITOR="nvim"
export XDG_CONFIG_HOME="$HOME/.config"

# pnpm
export PNPM_HOME="/Users/nel/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
