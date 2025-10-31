alias v="nvim"
alias ls="eza --all --color=always  --no-user --icons=always --long --tree --header  --recurse --level=1"
alias ls2="eza --all --color=always --no-user --icons=always --long --tree --header  --recurse --level=2"
alias ls3="eza --all --icons=always --no-user --long --tree --header  --recurse --level=3"
alias ls4="eza --all --icons=always --no-user --long --tree --header  --recurse --level=4"

alias checkout='git checkout $(git branch | fzf)'

# append to commands for searchable output
alias -g -- ~~='2>&1 | bat --paging=always --decorations=never --color=always'

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

# --- FZF SETUP ---
source <(fzf --zsh) # allow for fzf history widget

export FZF_DEFAULT_OPTS='
  --layout reverse
  --height ~30%
  --preview "bat --style=minimal -p --color=always {}"
  --color bg:-1,bg+:#2A2A37,fg:-1,fg+:#DCD7BA,hl:#938AA9,hl+:#c4746e
  --color header:#b6927b,info:#658594,pointer:#7AA89F
  --color marker:#7AA89F,prompt:#c4746e,spinner:#8ea49e
'

function f() {
    fzf --preview 'bat --theme=base16 --color=always --style=numbers --line-range=:500 {}' --height 90% --border
}

function fv () {
    fzf --preview 'bat --theme=base16 --color=always --style=numbers --line-range=:500 {}' --height 90% --border | xargs -r nvim
}

function fg () {
    # 1. Search for text in files using Ripgrep
    # 2. Interactively restart Ripgrep with reload action
    # 3. Open the file in Vim
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    INITIAL_QUERY="${*:-}"
    fzf --ansi --disabled --query "$INITIAL_QUERY" \
        --bind "start:reload:$RG_PREFIX {q}" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --delimiter : \
        --preview 'bat --theme=base16 --color=always {1}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(nvim {1} +{2})'
}

# --- --- --- ---

# --- SUBSTRING SEARCH ---
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
# --- --- --- ---

# --- PROMPT ---
## git branch in prompt
autoload -Uz vcs_info add-zsh-hook
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'
add-zsh-hook precmd vcs_info

## prompt line
NEWLINE=$'\n'
# PROMPT="${NEWLINE}%K{#2E3440}%F{#E5E9F0}$(date +%_I:%M%P) %K{#3b4252}%F{#ECEFF4} %n %K{#4c566a} %~ %f%k ❯ " # nord theme
PROMPT='${NEWLINE}%K{#32302f}%F{#d5c4a1}%D{%L:%M:%S} %K{#3c3836}%F{#d5c4a1} %n %K{#504945} %~ %f%k %F{green}${vcs_info_msg_0_}%f ❯ ' # warmer theme
# --- --- --- ---

# syntax highlighting prefers loading last
source $HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
