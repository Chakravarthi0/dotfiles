#!/bin/bash
set -e

BREWFILE="$(dirname "$0")/Brewfile"

# Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Check and install Brewfile dependencies
echo "📦 Checking Brewfile dependencies..."
if ! brew bundle check --file="$BREWFILE" &>/dev/null; then
    echo "➡️  Installing missing apps from Brewfile..."
    brew bundle install --file="$BREWFILE"
else
    echo "✅ All Brewfile dependencies already satisfied."
fi

# Symlink .zshrc
echo "🔗 Symlinking .zshrc..."
ln -sf "$(dirname "$0")/.zshrc" "$HOME/.zshrc"

# Install oh-my-zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "⚡ Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k if not installed
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "🎨 Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

echo "✨ Setup complete. Restart terminal."
