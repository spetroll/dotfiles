#!/bin/bash
set -e

# 1. Install System Dependencies
sudo apt update && sudo apt install -y zsh git curl fzf zoxide

# 2. Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    sudo chsh -s $(which zsh) $(whoami)
fi

# 3. Handle Zinit (Plugin Manager)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# 4. Symlink configs (This links the repo files to your home dir)
# Using -f to overwrite any existing default files
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh

echo "Done! Restart your terminal or run 'zsh'"
