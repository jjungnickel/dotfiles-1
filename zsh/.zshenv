# Unless -f is specified, .zshenv is sourced on all shell invocations.
# Consequently, there should be only critical commands environment in this file.

umask 022

# Set $PATH.
if [[ -f ~/.zpath ]]; then
  source ~/.zpath
fi

# Editor
if which emacsclient &> /dev/null; then
  export EDITOR="emacsclient -a emacs"
elif which vim &> /dev/null; then
  export EDITOR="vim"
fi
export VISUAL=$EDITOR

# Pager
LESSOPTS=(
    --force                             # Force open non-regular files
    --clear-screen                      # Print buffer from top of screen
    --dumb                              # Do not complain about terminfo errors
    --ignore-case                       # Like vim ignorecase + smartcase
    --no-lessopen                       # Ignore LESSOPEN preprocessor
    --long-prompt                       # Show position percentage
    --RAW-CONTROL-CHARS                 # Only interpret SGR escape sequences
    --chop-long-lines                   # Disable soft wrapping
    --no-init                           # Prevent use of alternate screen
    --tilde                             # Do not show nonextant lines as `~`
    --shift 8                           # Horizontal movement in columns
)
export LESS="${LESSOPTS[@]}"
export LESSSECURE='1'                   # More secure
export LESSHISTFILE='-'                 # No ~/.lesshst
export LESS_TERMCAP_md=$'\033[37m'      # Begin bold
export LESS_TERMCAP_so=$'\033[36m'      # Begin standout-mode
export LESS_TERMCAP_us=$'\033[4;35m'    # Begin underline
export LESS_TERMCAP_mb=$'\033[5m'       # Begin blink
export LESS_TERMCAP_se=$'\033[0m'       # End standout-mode
export LESS_TERMCAP_ue=$'\033[0m'       # End underline
export LESS_TERMCAP_me=$'\033[0m'       # End mode
export PAGER='less'                     # Should be a single word to avoid quoting problems
export SYSTEMD_LESS="${LESSOPTS[@]}"
unset LESSOPTS
export PAGER="less"

# Version control software.
export CVS_RSH="ssh"
export CVSEDITOR="emacs"
export RSYNC_RSH="ssh"

# Avoid issues with `gpg` as installed via Homebrew.
# https://stackoverflow.com/a/42265848/96656
export GPG_TTY=$(tty);

# OS-specific environment.
case $OSTYPE in
  darwin*)
    # Ignore reading of /etc/profile, which messes with $PATH. We re-enable
    # reading other system-wide zsh files in ~/.zprofile. See
    # http://www.zsh.org/mla/users/2015/msg00725.html for details.
    setopt no_global_rcs
    # Opt out of Homebrew analytics.
    export HOMEBREW_NO_ANALYTICS=1
    # On OSX, we install zplug via Homebrew.
    export ZPLUG_HOME=/usr/local/opt/zplug
    ;;
esac

# Set UTF-8 locale.
export LANG=en_US.UTF-8

# Source local environment.
if [[ -f ~/.zshenv.local ]]; then
  source ~/.zshenv.local
fi

# vim: ft=zsh
