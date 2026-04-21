# --- TERMINAL FIXES ---
# Prevent artifacts on Windows SSH
export PF_INFO="ascii os host kernel uptime pkgs memory"
export PF_COL1=4
export PF_COL2=7
export PF_COL3=1
export TERM=xterm-256color

# Run pfetch for that sweet startup look
pfetch

# --- ZINIT PLUGIN MANAGER ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    print -P "%F{33} ▓▒░ Installing Zinit...%f"
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Load plugins asynchronously
zinit wait lucid for \
    atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggestions_start" \
        zsh-users/zsh-autosuggestions \
    blockf \
        zsh-users/zsh-completions

# --- SHELL OPTIONS ---
setopt autocd              # Change directory by just typing its name
setopt interactive_comments # Allow comments in interactive shell
setopt magicequalsubst     # Parameter expansion for arguments like --prefix=$HOME
setopt notify              # Report status of background jobs immediately

# --- HISTORY SETTINGS ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory       # Append to history file instead of overwriting
setopt sharehistory        # Share history between different sessions
setopt hist_ignore_dups    # Ignore immediate duplicates
setopt hist_ignore_space   # Ignore commands starting with a space

# --- KEYBINDINGS ---
bindkey -e                 # Use emacs mode (default)
# Better history search with Up/Down arrows
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# --- PROMPT ---
# Minimalist prompt with Git info
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{cyan}(%b)%f '
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f %F{cyan}${vcs_info_msg_0_}%f$ '

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
# Correctly source LS_COLORS (Fixed for Zsh)
[ -f ~/.dotfiles/.LS_COLORS ] && source ~/.dotfiles/.LS_COLORS
