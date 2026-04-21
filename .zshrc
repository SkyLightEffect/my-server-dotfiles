# --- TERMINAL & LOCALE ---
export LANG=en_US.UTF-8
export TERM=xterm-256color

# --- PFETCH CONFIG (No-Query Mode) ---
export PF_INFO="ascii os host kernel uptime pkgs memory"
export PF_COL1=4
export PF_COL2=7
export PF_COL3=1
pfetch

# --- ZINIT PLUGIN MANAGER ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    print -P "%F{33} ▓▒░ Installing Zinit...%f"
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Stable Plugin Loading
zinit wait lucid for \
    atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    zsh-users/zsh-autosuggestions \
    blockf \
        zsh-users/zsh-completions

# --- SHELL OPTIONS ---
setopt prompt_subst          # CRITICAL: This fixes the ${vcs_info_msg_0_} error
setopt autocd
setopt interactive_comments
setopt magicequalsubst
setopt notify

# --- HISTORY ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_dups
setopt hist_ignore_space

# --- KEYBINDINGS ---
bindkey -e
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# --- PROMPT SETUP ---
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{242}(%b)%f '
# Clean prompt: User@Host:Path [GitBranch] $
PROMPT='%F{042}%n@%m%f:%F{033}%~%f %F{242}${vcs_info_msg_0_}%f$ '

# --- ALIASES ---
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias t='tmux'
alias ta='tmux attach -t'
alias dot='cd ~/dotfiles-dev'

# --- LOAD COLORS ---
[ -f ~/.dotfiles/.LS_COLORS ] && source ~/.dotfiles/.LS_COLORS
