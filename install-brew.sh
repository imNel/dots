# Install xcode cli, required for brew
xcode-select --install

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# activate brew
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# install deps for dotfiles
brew bundle --file ./homebrew/Brewfile

# set default shell to fish
chsh -s /opt/homebrew/bin/fish

