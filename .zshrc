# --- TERMINAL FIXES ---
export PF_INFO="ascii os host kernel uptime pkgs memory"
export PF_COL1=4; export PF_COL2=7; export PF_COL3=1
export TERM=xterm-256color

# --- HISTORY & BASIC SETTINGS ---
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
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

# --- ZINIT (Plugin Loader) ---
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"
if [ -f "${ZINIT_HOME}/zinit.zsh" ]; then
    source "${ZINIT_HOME}/zinit.zsh"
    zinit light zdharma-continuum/fast-syntax-highlighting
    zinit light zsh-users/zsh-autosuggestions
fi

# --- COMPLETION (Optimized!) ---
autoload -Uz compinit
# Check if the cache is older than 24h to save time
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m-1) ]]; then
    compinit -C
else
    compinit
fi
zstyle ':completion:*' menu select
_comp_options+=(globdots)

# --- DYNAMIC PROMPT (Oliver-Style with Root-Check) ---
autoload -Uz colors && colors
if [[ $EUID -eq 0 ]]; then
  U_COL="red"; S_SYM="#"
else
  U_COL="green"; S_SYM="$"
fi
PROMPT="%F{$U_COL}%n%f%F{$U_COL}@%f%F{$U_COL}%m%f: %F{cyan}%~%f%F{white} $S_SYM %f"

# --- ALIASES ---
alias grep="grep --color=auto"
alias tmux="tmux -2"
alias dots-update="cd ~/dotfiles-dev && git pull && bash init.sh"

if command -v lsd &> /dev/null; then
  alias ls="lsd"
  alias l='ls -l'
  alias ll='ls -la'
  alias la='ls -a'
  alias lla='ls -la'
  alias lt='ls --tree'
  alias clear='clear && echo "" && pfetch 2> /dev/null'
fi

# --- TMUX AUTO-START ---
if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
  tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux 2> /dev/null
fi

# --- STARTUP ---
echo ""
pfetch 2> /dev/null
cd

# --- COLORS LOAD ---
[ -f ~/.dotfiles/.LS_COLORS ] && export LS_COLORS=$(cat ~/.dotfiles/.LS_COLORS)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
