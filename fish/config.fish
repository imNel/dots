set fish_greeting
set -U EDITOR nvim
set -g fish_key_bindings fish_vi_key_bindings

fish_add_path "/opt/homebrew/bin/"

alias lg="lazygit"
alias ls="eza"

starship init fish | source
zoxide init fish | source
fnm env --use-on-cd --shell fish | source

# pnpm
set -gx PNPM_HOME "/Users/nel/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
