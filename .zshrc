HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt COMPLETE_ALIASES
unsetopt beep

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


#syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2> /dev/null

# aliases
alias tmux="tmux -2"

# tmux
if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
  tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi


neofetch
