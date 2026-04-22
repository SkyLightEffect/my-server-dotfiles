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

# --- ZINIT SETUP (Force HTTPS for new containers) ---
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"
if [ -f "${ZINIT_HOME}/zinit.zsh" ]; then
    # This ensures Zinit uses HTTPS even if Git defaults are different
    zstyle ':zinit:*' git-clone-command "git clone --depth 1"
    
    source "${ZINIT_HOME}/zinit.zsh"
    
    # Load plugins via HTTPS
    zinit light zdharma-continuum/fast-syntax-highlighting
    zinit light zsh-users/zsh-autosuggestions
fi

# --- COMPLETION ---
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.compdump(#qN.m-1) ]]; then
    compinit -C
else
    compinit
fi
zstyle ':completion:*' menu select
_comp_options+=(globdots)

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

cd ~/dotfiles-dev

# --- TMUX AUTOSTART ---
# Start tmux automatically if we are logged in via SSH and not already in a tmux session
if [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
    exec tmux new-session -A -s base
fi

# --- STARTUP ---
echo ""
pfetch 2> /dev/null
cd
