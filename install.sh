#!/bin/bash
set -e

# --- 1. Configuration ---
# Replace with your actual GitHub username
GH_USER="spetroll" 
DOT_DIR="$HOME/.dotfiles"
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

echo "🚀 Starting terminal bootstrap..."

# --- 2. System Dependencies ---
# Install the binaries BEFORE Zsh starts so Zinit doesn't break
echo "📦 Installing system dependencies..."
sudo apt update && sudo apt install -y zsh git curl fzf zoxide

# --- 3. Dotfiles Repository ---
if [ ! -d "$DOT_DIR" ]; then
    echo "📂 Cloning dotfiles..."
    git clone https://github.com/$GH_USER/dotfiles.git "$DOT_DIR"
else
    echo "🔄 Updating dotfiles..."
    cd "$DOT_DIR" && git pull
fi

# --- 4. Clean up "Weird States" ---
# Nuking Zinit and p10k cache ensures a clean compilation of plugins
echo "🧹 Cleaning previous Zinit state..."
rm -rf "${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
rm -rf ~/.cache/p10k-instant-prompt-*

# --- 5. Symlinking ---
echo "🔗 Creating symlinks..."
ln -sf "$DOT_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOT_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

# --- 6. Initialize Zinit ---
if [ ! -d "$ZINIT_HOME" ]; then
    echo "⚙️  Installing Zinit..."
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# --- 7. Finalize Shell ---
echo "✅ Setting Zsh as default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
    sudo chsh -s $(which zsh) $(whoami)
fi

echo "✨ Setup complete! Switching to Zsh..."
# This re-launches Zsh; Zinit will now download plugins cleanly
exec zsh -l
