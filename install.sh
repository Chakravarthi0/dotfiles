#!/bin/bash
set -e

BREWFILE="$(dirname "$0")/Brewfile"

# Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
    echo ":beer: Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Check and install Brewfile dependencies
echo ":package: Checking Brewfile dependencies..."
if ! brew bundle check --file="$BREWFILE" &>/dev/null; then
    echo ":arrow_right:  Installing missing apps from Brewfile..."
    brew bundle install --file="$BREWFILE"
else
    echo ":white_tick: All Brewfile dependencies already satisfied."
fi

# Symlink .zshrc
echo ":link: Symlinking .zshrc..."
ln -sf "$(dirname "$0")/.zshrc" "$HOME/.zshrc"

# Symlink .zshrc safely
DOTFILES_ZSHRC="$(cd "$(dirname "$0")" && pwd)/.zshrc"
if [ -L "$HOME/.zshrc" ] || [ -f "$HOME/.zshrc" ]; then
    rm -f "$HOME/.zshrc"
fi
ln -s "$DOTFILES_ZSHRC" "$HOME/.zshrc"

# Install Oh My Zsh plugins if not present
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
    echo "Installing zsh-completions..."
    git clone https://github.com/zsh-users/zsh-completions.git "$ZSH_CUSTOM/plugins/zsh-completions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Install oh-my-zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ":zap: Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k if not installed
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo ":art: Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

echo ":sparkles: Setup complete. Restart terminal."