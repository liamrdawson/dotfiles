function f
    fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' --height 90% --border
end

function fv
    fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' --height 90% --border | xargs -r nvim
end
