HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt COMPLETE_ALIASES
unsetopt beep

setopt auto_cd # cd into dirs with typing in dir name
setopt auto_pushd # keep directory history
setopt pushd_ignore_dups # ignore directory duplicatiore for dir history
setopt extended_glob # enables globbing patterns

# vi mode
bindkey -v
#export KEYTIMEOUT=1

#change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
        echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new promp


# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
# zstyle :compinstall filename '/home/leon/.zshrc'
# zstyle ':completion::complete:*' gain-privileges 1

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)               # Include hidden files.

# Colors
autoload -Uz colors && colors

# Promt ZSH
autoload  -Uz promptinit
promptinit
prompt oliver


PROMPT="%F{green}%n%f%F{green}@%f%F{green}%m%f: %F{cyan}%~%f%F{white} $ %f"

# plugins
PLUGINS=~/.zsh/plugins/

#syntax-highlighting; should be last.
source $PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
source $PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh 2> /dev/null

# aliases
alias tmux="tmux -2"
alias tmrl="rm -rf ~/.tmux/ && tmux source ~/.tmux.conf"

if command -v lsd &> /dev/null; then
  alias ls="lsd"
  alias l='ls -l'
  alias ll='ls -la'
  alias la='ls -a'
  alias lla='ls -la'
  alias lt='ls --tree'
  alias clear='clear && (neofetch || pfetch)'
fi

alias dots-update="rm -rf ~/.dotfiles && git clone https://github.com/SkyLightEffect/my-server-dotfiles.git ~/.dotfiles && sh ~/.dotfiles/init.sh && rm -rf ~/.dotfiles && sudo git clone https://github.com/SkyLightEffect/my-server-dotfiles.git ~/.dotfiles && sudo ~/.dotfiles/init.sh"

if command -v gping &> /dev/null; then
  alias ping="gping"
fi

# automatically start tmux session on shell startup
if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
  tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux 2> /dev/null
fi

# export TERM=xterm-256color

pfetch 2> /dev/null

if [ $? -ne 0 ]; then
  neofetch 2> /dev/null
fi

cd

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#export LS_COLORS="$(vivid generate nord)"

export LS_COLORS=$(cat ~/.dotfiles/.LS_COLORS)
