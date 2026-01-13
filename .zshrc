# 1. Instant Prompt (Keep this at the top!)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 2. Zinit Bootstrap
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# 3. Load Theme & Plugins
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# 4. Snippets (Useful OMZ bits)
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# 5. Load your local P10K config (The one you just generated)
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# 6. History & Keybindings
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history
setopt sharehistory
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# 7. Shell Integrations (Assumes you installed fzf/zoxide via apt)
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# 8. Your Personal Aliases
alias ls='ls --color=auto'
alias c='clear'
alias proxmox='ssh root@192.168.178.10'
