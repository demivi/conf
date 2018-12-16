#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ $DISPLAY ]] && shopt -s checkwinsize

PS1='[\u@\h \W]\$ '

case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

    ;;
  screen*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
esac

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

# Set default editor
export EDITOR=vim

# Set LS_COLORS environment variable (added for fd)
eval $(dircolors)

# Disable Ctrl-S
stty -ixon
bind 'Control-s: '

# Vi command line editing mode
set -o vi

# Source fzf configuration
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash

# Rebind Alt-C to CTRL-F
bind "$(bind -s | grep '^"\\ec"' | sed 's/ec/C-f/')"
[[ $- =~ i ]] && bind '"\ec": nop'
[[ $- =~ i ]] && bind -m vi-command '"\ec": nop'

# Define fzf commands
export FZF_DEFAULT_COMMAND="fd -H -I"
export FZF_CTRL_T_COMMAND="fd . /"
export FZF_ALT_C_COMMAND="fd -t d -H -I"

# Define Ctrl+p behavior
fzfvim() {
    file=$(fzf)

    if [ $file ]
    then
        vim $file
        history -s vim $file
    fi
}

bind -x '"\C-p": fzfvim;'
