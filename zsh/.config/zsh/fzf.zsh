# --- FZF SETUP ---
source <(fzf --zsh) # allow for fzf history widget

export FZF_DEFAULT_OPTS='
  --layout reverse
  --height ~30%
  --color bg:-1,bg+:#2A2A37,fg:-1,fg+:#DCD7BA,hl:#938AA9,hl+:#c4746e
  --color header:#b6927b,info:#658594,pointer:#7AA89F
  --color marker:#7AA89F,prompt:#c4746e,spinner:#8ea49e
'

# Fuzzy find a file.
function f() {
    local INITIAL_QUERY="${*:-}" # All positional parameters or empty stirng
    fzf --query "$INITIAL_QUERY" \
        --preview 'bat --theme=base16 --color=always --style=numbers --line-range=:500 {}' \
        --height 90% --border
}

# Fuzzy find a file and open in neovim.
function fv () {
    local INITIAL_QUERY="${*:-}"
    fzf --query "$INITIAL_QUERY" \
        --preview 'bat --theme=base16 --color=always --style=numbers --line-range=:500 {}' \
        --height 90% --border | xargs -r nvim
}

# Ripgrep for a word and use fzf for fuzzy finding within results.
function fg () {
    # 1. Search for text in files using Ripgrep
    # 2. Interactively restart Ripgrep with reload action
    # 3. Open the file in Vim
    local RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    # Here we're using the ${parameter:-word} expansion to expand the $* special
    # parameter (all positional parameters). So, "Give me what's in parameter
    # or otherwise give me word (even if that's an empty string)".
    local INITIAL_QUERY="${*:-}"
    fzf --ansi --disabled --query "$INITIAL_QUERY" \
        --bind "start:reload:$RG_PREFIX '{q}'" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --delimiter : \
        --preview 'bat --theme=base16 --color=always --line-range=:500 {1}' \
        --height 90% \
        --preview-window 'right,50%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(nvim {1} +{2})'
}
