# --- TERMINAL FIXES ---
export PF_INFO="ascii os host kernel uptime pkgs memory"
export PF_COL1=4; export PF_COL2=7; export PF_COL3=1
export TERM=xterm-256color
export EDITOR="vim"

# --- HISTORY & BASIC SETTINGS ---
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
# Best Practice: Write commands immediately to history and share across all Tmux panes
setopt INC_APPEND_HISTORY SHARE_HISTORY EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS HIST_IGNORE_SPACE
setopt COMPLETE_ALIASES auto_cd auto_pushd pushd_ignore_dups extended_glob
unsetopt beep

# --- VI MODE ---
bindkey -v
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() { zle -K viins; echo -ne "\e[5 q" }
zle -N zle-line-init
echo -ne '\e[5 q'
preexec() { echo -ne '\e[5 q' ;}

# --- FZF INTEGRATION ---
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# --- COMPLETION (Must be loaded BEFORE fzf-tab) ---
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.compdump(#qN.m-1) ]]; then
    compinit -C
else
    compinit
fi
zstyle ':completion:*' menu select
# Enable colors for fzf-tab descriptions
zstyle ':completion:*:descriptions' format '[%d]'
_comp_options+=(globdots)

# --- ZINIT SETUP ---
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"
if [ -f "${ZINIT_HOME}/zinit.zsh" ]; then
    # This ensures Zinit uses HTTPS even if Git defaults are different
    zstyle ':zinit:*' git-clone-command "git clone --depth 1"
    source "${ZINIT_HOME}/zinit.zsh"
    
    # Load plugins via HTTPS
    zinit light zsh-users/zsh-completions
    zinit light zdharma-continuum/fast-syntax-highlighting
    zinit light zsh-users/zsh-autosuggestions
    
    # Interactive TAB menu with FZF (Requires compinit to be loaded first)
    zinit light Aloxaf/fzf-tab
    # Opens fzf-tab as a neat Tmux popup (optional)
    zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
fi

# --- PROMPT & ALIASES ---
autoload -Uz colors && colors
if [[ $EUID -eq 0 ]]; then
  U_COL="red"; S_SYM="#"
else
  U_COL="green"; S_SYM="$"
fi
PROMPT="%F{$U_COL}%n%f%F{$U_COL}@%f%F{$U_COL}%m%f: %F{cyan}%~%f%F{white} $S_SYM %f"

alias grep="grep --color=auto"
alias tmux="tmux -2"
alias t="tmux attach-session -t base || tmux new-session -s base"
alias dots-update="cd ~/.dotfiles && git pull && bash init.sh"

if command -v lsd &> /dev/null; then
  alias ls="lsd"
  alias l='ls -l'
  alias ll='ls -la'
  alias la='ls -a'
  alias lla='ls -la'
  alias lt='ls --tree'
  alias clear='clear && echo "" && pfetch 2> /dev/null'
fi

# --- STARTUP ---
# 1. Initial visual feedback (only for login shells)
if [[ -o login ]]; then
    echo ""
    pfetch 2> /dev/null
fi

# 2. Tmux Autostart (MUST be at the very end because of 'exec')
if [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
    exec tmux new-session -A -s base
fi
