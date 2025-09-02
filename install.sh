#!/bin/bash
set -e

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install all brew apps
brew bundle --file=~/dotfiles/Brewfile

# Symlink dotfiles
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh

# Install Oh My Zsh (or Antidote, if preferred)
if [ ! -d "${ZSH:-$HOME/.oh-my-zsh}" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "Setup complete! Restart your terminal."
