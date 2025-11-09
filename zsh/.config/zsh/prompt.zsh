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
