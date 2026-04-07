# config.nu
#
# Installed by:
# version = "0.109.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

# ENV
$env.config.buffer_editor = "nvim"
$env.path ++= ["~/.local/bin"]
$env.path ++= ["/opt/homebrew/bin"]
$env.PATH ++= ["~/.cargo/bin"]

$env.config.show_banner = false

use apis.nu *

if not (which fnm | is-empty) {
    ^fnm env --json | from json | load-env

    $env.PATH = $env.PATH | prepend ($env.FNM_MULTISHELL_PATH | path join (if $nu.os-info.name == 'windows' {''} else {'bin'}))
    $env.config.hooks.env_change.PWD = (
        $env.config.hooks.env_change.PWD? | append {
            condition: {|| ['.nvmrc' '.node-version', 'package.json'] | any {|el| $el | path exists}}
            code: {|| ^fnm use --install-if-missing}
        }
    )
}

# ALIASES
alias v = nvim

# FUNCTIONS
def lz [depth: int = 1] {
  ^eza --all --no-user --icons=always --long --tree --header --recurse --level $depth
}

# Recursively list the contents of a directory to a chosen depth
def lsr [depth: int = 1] {
  glob **/* --depth $depth 
  | each { |p| ls -l $p } 
  | flatten 
  | select name type size modified
  | update name { |row| $row.name | path relative-to (pwd) }
}

def f [query?: string] {
    ( fzf --query (  $query | default '' )
        --preview 'bat --theme=base16 --color=always --style=numbers --line-range=:500 {}' 
        --height 90% 
        --border )
}

# 1. Search for text in files using Ripgrep
# 2. Interactively restart Ripgrep with reload action
# 3. Open the file in Vim
def fg [query?: string] {
    let rg_prefix = "rg --column --line-number --no-heading --color=always --smart-case"
    
    ( ^fzf --ansi --disabled --query ($query | default "") 
        --bind $"start:reload:($rg_prefix) '{q}'" 
        --bind $"change:reload:sleep 0.1; ($rg_prefix) {q} || true" 
        --delimiter : 
        --preview 'bat --theme=base16 --color=always --line-range=:500 {1}' 
        --height 90% 
        --preview-window 'right,50%,border-bottom,+{2}+3/3,~3' 
        --bind 'enter:become(nvim {1} +{2})' )
}

# PROMPT
# needs to stay at the end of config according to: https://starship.rs/
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
