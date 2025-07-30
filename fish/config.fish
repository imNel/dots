set fish_greeting
set -U EDITOR nvim
fish_default_key_bindings

fish_add_path /opt/homebrew/bin/
fish_add_path $HOME/.local/bin/

alias lg="lazygit"
alias ls="eza"
alias l="ll"
alias hpm="pnpm hpm"

starship init fish | source
zoxide init fish | source

# pnpm
set -gx PNPM_HOME "/Users/nel/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
