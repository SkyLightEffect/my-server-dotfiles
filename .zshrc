# --- TERMINAL FIXES (Windows/SSH) ---
export PF_INFO="ascii os host kernel uptime pkgs memory"
export PF_COL1=4
export PF_COL2=7
export PF_COL3=1
export TERM=xterm-256color

# --- HISTORY & BASIC SETTINGS ---
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt COMPLETE_ALIASES
unsetopt beep
setopt auto_cd           # cd into dirs with typing in dir name
setopt auto_pushd        # keep directory history
setopt pushd_ignore_dups # ignore directory duplicates
setopt extended_glob     # enables globbing patterns

# --- VI MODE ---
bindkey -v
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' 
preexec() { echo -ne '\e[5 q' ;}

# --- ZINIT (Plugin Loader) ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions

# --- COMPLETION ---
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# --- COLORS & PROMPT ---
autoload -Uz colors && colors
PROMPT="%F{green}%n%f%F{green}@%f%F{green}%m%f: %F{cyan}%~%f%F{white} $ %f"

# --- ALIASES ---
alias grep="grep --color=auto"
alias tmux="tmux -2"
alias tmrl="rm -rf ~/.tmux/ && tmux source ~/.tmux.conf"
alias dots-update="rm -rf ~/.dotfiles && git clone https://github.com/SkyLightEffect/my-server-dotfiles.git ~/.dotfiles && sh ~/.dotfiles/init.sh && rm -rf ~/.dotfiles && sudo git clone https://github.com/SkyLightEffect/my-server-dotfiles.git ~/.dotfiles && sudo ~/.dotfiles/init.sh"

if command -v lsd &> /dev/null; then
  alias ls="lsd"
  alias l='ls -l'
  alias ll='ls -la'
  alias la='ls -a'
  alias lla='ls -la'
  alias lt='ls --tree'
  alias clear='clear && echo "" && pfetch 2> /dev/null || neofetch 2> /dev/null'
fi

if command -v gping &> /dev/null; then
  alias ping="gping"
fi

# --- AUTOMATIC TMUX START ---
if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
  tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux 2> /dev/null
fi

# --- STARTUP (With empty line) ---
echo ""
pfetch 2> /dev/null || neofetch 2> /dev/null
cd

# --- COLORS LOAD ---
[ -f ~/.dotfiles/.LS_COLORS ] && export LS_COLORS=$(cat ~/.dotfiles/.LS_COLORS)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
