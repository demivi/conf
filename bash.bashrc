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
export FZF_ALT_C_COMMAND="fd -t d -H -I"

# Change Ctrl+t behavior
ctrl_t_root () {
    FZF_CTRL_T_COMMAND="fd . /"
    fzf-file-widget
}

ctrl_t () {
    FZF_CTRL_T_COMMAND="fd -H -I"
    fzf-file-widget
}

bind -x '"\C-t": ctrl_t_root;'
bind -x '"\C-o": ctrl_t;'

# Define Ctrl+p behavior
fzfvim() {
    file=$(fzf --height 40% --reverse)

    if [ $file ]
    then
        vim $file
        history -s vim $file
    fi
}

bind -x '"\C-p": fzfvim;'

_gen_fzf_default_opts() {

local color04='#bdae93'
local color06='#ebdbb2'
local color0A='#fabd2f'
local color0B='#b8bb26'
local color0C='#8ec07c'
local color0D='#83a598'

export FZF_DEFAULT_OPTS="
  --color=spinner:$color0A,hl:$color0B
  --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C
  --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0B
"

}

_gen_fzf_default_opts
