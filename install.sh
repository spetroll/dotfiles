#!/bin/bash
set -e

# --- 1. Configuration ---
GH_USER="spetroll" 
DOT_DIR="$HOME/.dotfiles"
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

echo "🚀 Starting terminal bootstrap..."

# --- 2. System Dependencies ---
# Determine if sudo is needed/available
if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
else
    SUDO=""
fi

echo "📦 Installing system dependencies..."
$SUDO apt update && $SUDO apt install -y zsh git curl fzf zoxide

# --- 3. Dotfiles Repository ---
if [ ! -d "$DOT_DIR" ]; then
    echo "📂 Cloning dotfiles..."
    git clone https://github.com/$GH_USER/dotfiles.git "$DOT_DIR"
else
    echo "🔄 Updating dotfiles..."
    cd "$DOT_DIR" && git pull
fi

# --- 4. Clean up "Weird States" ---
echo "🧹 Cleaning previous Zinit/Prompt state..."
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
# SAFETY CHECK: Only change shell if the binary actually exists and is executable
ZSH_PATH=$(command -v zsh)
if [ -n "$ZSH_PATH" ] && [ -x "$ZSH_PATH" ]; then
    echo "✅ Setting shell to $ZSH_PATH"
    $SUDO usermod -s "$ZSH_PATH" "$(whoami)"
else
    echo "❌ ERROR: Zsh not found. Keeping current shell for safety."
fi

echo "✨ Setup complete! Switching to Zsh..."
# Use absolute path to zsh to avoid "command not found" in current bash session
exec "$ZSH_PATH" -l
