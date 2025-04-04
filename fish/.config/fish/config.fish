# load_nvm >/dev/stderr

set -U fish_greeting ""

set -q XDG_CONFIG_HOME || set -U XDG_CONFIG_HOME $HOME/.config

# bobthefish settings
set -g theme_nerd_fonts yes
set -g theme_display_node yes
set -g theme_title_display_path yes
set -g theme_color_scheme nord
set -g theme_newline_prompt '〉'

fzf --fish | source

# Aliases
## eza
alias lz="eza --all --icons=always --long --tree --header  --recurse --level=1"
alias lz2="eza --all --icons=always --long --tree --header  --recurse --level=2"
alias lz3="eza --all --icons=always --long --tree --header  --recurse --level=3"
alias lz4="eza --all --icons=always  --long --tree --header  --recurse --level=4"

## nvim
alias v="nvim"

## git
alias g="git"
alias gg="lazygit"

### Set the directory that the .dotfiles repo tracks to home directory.
alias config="git --git-dir=$HOME/Development/.dotfiles --work-tree=$HOME"
## pnpm
set -gx PNPM_HOME "/Users/liam/Library/pnpm"

## Directory shortcuts
alias dev="cd ~/Development"



if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# You must call it on initialization or listening to directory switching won't work
# load_nvm >/dev/stderr
