
export MANPAGER="nvim +Man!"

# load modules
zmodload zsh/complist
autoload -Uz compinit && compinit
autoload -U colors && colors

# cmp opts
zstyle ':completion:*' menu select # tab opens cmp menu
zstyle ':completion:*' special-dirs true # force . and .. in cmp menu 
zstyle ':completion:*' squeeze-slashes false # allow /*/ style expansion

# main opts
setopt prompt_subst
setopt append_history inc_append_history share_history # on exit, history appends rather than overwrites; history is appended as soon as cmd executes; history is shared across sessions
setopt auto_menu menu_complete # cmp first match
setopt auto_param_slash # / when a dir is completed
setopt no_case_glob no_case_match # case insensitive cmpc
setopt globdots # include dotfiles
setopt extended_glob # match ^ # ~
setopt interactive_comments # allow comments in shell
unsetopt prompt_sp # don't autoclean blank lines

# history opts
HISTSIZE=1000000
SAVEHIST=1000000
HISTCONTROL=ignoreboth # consecutive duplicates & commands starting with space are not saved
