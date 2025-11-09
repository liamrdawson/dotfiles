alias v="nvim"
alias ls="eza --all --color=always  --no-user --icons=always --long --tree --header  --recurse --level=1"
alias ls2="eza --all --color=always --no-user --icons=always --long --tree --header  --recurse --level=2"
alias ls3="eza --all --icons=always --no-user --long --tree --header  --recurse --level=3"
alias ls4="eza --all --icons=always --no-user --long --tree --header  --recurse --level=4"

alias checkout='git checkout $(git branch | fzf)'

# append to commands for searchable output
alias -g -- ~~='2>&1 | bat --paging=always --decorations=never --color=always'
