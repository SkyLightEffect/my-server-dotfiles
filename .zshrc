# --- PFETCH CONFIG (Fixes Terminal Artifacts) ---
export PF_INFO="ascii os host kernel uptime pkgs memory"
export PF_COL1=4
export PF_COL2=7
export PF_COL3=1

# Run pfetch
pfetch

# --- ZINIT ASYNC LOADER ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    print -P "%F{33} ▓▒░ Installing Zinit...%f"
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

zinit wait lucid for \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-syntax-highlighting

# --- ALIASES & SETTINGS ---
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias t='tmux'
alias ta='tmux attach -t'

# Load LS_COLORS if file exists
[ -f ~/.dotfiles/.LS_COLORS ] && source ~/.dotfiles/.LS_COLORS
