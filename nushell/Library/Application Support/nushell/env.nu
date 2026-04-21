$env.PATH = ($env.PATH | prepend "/opt/homebrew/bin")
const secrets_path = ($nu.default-config-dir | path join "secrets.nu")
source-env $secrets_path
const api_path = ($nu.default-config-dir | path join "api.json")
$env.api = open $api_path
# env.nu
#
# Installed by:
# version = "0.109.1"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.
$env.STARSHIP_SHELL = "nu"
def create_left_prompt [] { starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)' }
# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {||| create_left_prompt }
$env.GITLAB_TOKEN = ($env | get -o NPM_TOKEN | default "")
$env.GITLAB_API_TOKEN = ($env | get -o NPM_TOKEN | default "")
$env.CI_JOB_TOKEN = ($env | get -o NPM_TOKEN | default "")
$env.FNM_DIR = $"($env.HOME)/.local/share/fnm"
$env.FNM_LOGLEVEL = "info"
$env.FNM_NODE_DIST_MIRROR = "https://nodejs.org/dist"
$env.FNM_COREPACK_ENABLED = "false"
$env.FNM_VERSION_FILE_STRATEGY = "local"
$env.FNM_RESOLVE_ENGINES = "true"
$env.FNM_ARCH = "arm64"
let fnm_path = $"($env.HOME)/.local/share/fnm"
$env.PATH = (
    $env.PATH | split row (char esep) | prepend $"($fnm_path)/aliases/default/bin" | prepend $"($fnm_path)/bin"
)
use std "path add"
fnm env --json | from json | load-env
path add $env.FNM_MULTISHELL_PATH
