#!/bin/zsh

typeset -U path # Prevent duplicate entries on the $PATH

export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(
	git
	zsh-syntax-highlighting
)

alias be="bundle exec"
alias bl="bundle exec rails linters -a"
alias brewery="brew update && brew upgrade && brew upgrade --cask && brew cleanup"
alias c="clear"
alias gitconfig="code $HOME/.gitconfig"
alias macsetup="code $HOME/.macsetup"
alias show_path="tr ':' '\n' <<< \"$PATH\""
alias speedtest="networkQuality"
alias test-reset="bundle exec rake db:drop RAILS_ENV=test && bundle exec rake db:create RAILS_ENV=test && bundle exec rails db:schema:load RAILS_ENV=test"
alias zshconfig="code $HOME/.zshrc"
alias gb='git branch --sort=-committerdate'
# Alias to create a file along with its parent directories if they do not exist:
alias stouch='function _mkfile() { mkdir -p "$(dirname "$1")" && touch "$1"; }; _mkfile'
alias killpg='pkill -9 postgres'

# Spotify Downloader - Download playlists and songs easily
alias spotify='/Users/letiesperon/.local/bin/spotify-download'

source $ZSH/oh-my-zsh.sh

# Function to check or create and run spec file for a Rails app using RSpec,
# used from VSCode shortcut (configured from Terminal->Configure Tasks)
run_or_create_spec() {
  # Get the file path from the argument
  original_file_path="$1"

  # Construct the spec file path
  # Replace "app/" with "spec/":
  modified_file_path="${original_file_path//app\//spec/}"
  # Add "_spec" before the extension:
  modified_file_path="${modified_file_path%.*}_spec.${original_file_path##*.}"

  # Convert the absolute path to a relative path
  relative_modified_file_path=$(echo "$modified_file_path" | sed "s|^$(pwd)/||")

  # Check if the spec file exists
  if [ -f "$modified_file_path" ]; then
    echo "Running spec file: $relative_modified_file_path"
    bundle exec rspec "$modified_file_path"
  else
    echo "Spec file does not exist. Creating: $relative_modified_file_path"
    mkdir -p "$(dirname "$modified_file_path")"
    touch "$modified_file_path"
    echo "# frozen_string_literal: true" >> "$modified_file_path"

    # Open the file in Visual Studio Code:
    code "$modified_file_path"
  fi
}

rspec_diff() {
  # 1) Specs changed against master (added, copied, modified or renamed)
  local diff_specs
  diff_specs=$(git diff --name-only --diff-filter=ACMR master...HEAD | grep '_spec\.rb$' || true)

  # 2) Specs in uncommitted state (staged + unstaged)
  local status_specs
  status_specs=$(git status --porcelain \
    | grep '_spec\.rb$' \
    | awk '($1 ~ /^D/) { next } ($1 ~ /^R/) { sub(/.* -> /, ""); print; next } { print $2 }' || true)

  # 3) Combine lists, dedupe, and filter out empty lines
  local specs=()
  local line
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    specs+=("$line")
  done < <(
    printf "%s\n%s\n" "$diff_specs" "$status_specs" \
    | grep -v '^$' \
    | sort -u
  )

  # 4) If no specs, notify and exit
  if [ ${#specs[@]} -eq 0 ]; then
    echo "No changed tests detected."
    return 0
  fi

  # 5) Print summary and execute
  echo "Executing tests for:"
  printf "  %s\n" "${specs[@]}"
  bundle exec rspec "${specs[@]}"
}

alias spotify-failed="/Users/letiesperon/.local/bin/spotify-failed"

export PATH="$HOME/.local/bin:$PATH"

# Source khepri helper functions:
[ -f ~/Desktop/Projects/khepri/.khepri.bashrc ] && source ~/Desktop/Projects/khepri/.khepri.bashrc

# Load SSH key into agent for Docker to access private GitHub repos (e.g., wall-e).
# Required for `docker compose up` in khepri - containers use SSH_AUTH_SOCK to clone dependencies.
ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null

# ----

eval "$(direnv hook zsh)"
# BEGIN_AWS_SSO_CLI

# AWS SSO requires `bashcompinit` which needs to be enabled once and
# only once in your shell.  Hence we do not include the two lines:
#
# autoload -Uz +X compinit && compinit
# autoload -Uz +X bashcompinit && bashcompinit
#
# If you do not already have these lines, you must COPY the lines 
# above, place it OUTSIDE of the BEGIN/END_AWS_SSO_CLI markers
# and of course uncomment it

__aws_sso_profile_complete() {
     local _args=${AWS_SSO_HELPER_ARGS:- -L error}
    _multi_parts : "($(/opt/homebrew/bin/aws-sso ${=_args} list --csv Profile))"
}

aws-sso-profile() {
    local _args=${AWS_SSO_HELPER_ARGS:- -L error}
    local _sso=""
    local _profile=""
    
    if [ -n "$AWS_PROFILE" ]; then
        echo "Unable to assume a role while AWS_PROFILE is set"
        return 1
    fi

    # Parse arguments
    while [ $# -gt 0 ]; do
        case "$1" in
            -S|--sso)
                shift
                if [ -z "$1" ]; then
                    echo "Error: -S/--sso requires an argument"
                    return 1
                fi
                _sso="$1"
                shift
                ;;
            -*)
                echo "Unknown option: $1"
                echo "Usage: aws-sso-profile [-S|--sso <sso-instance>] <profile>"
                return 1
                ;;
            *)
                if [ -z "$_profile" ]; then
                    _profile="$1"
                else
                    echo "Error: Multiple profiles specified"
                    return 1
                fi
                shift
                ;;
        esac
    done

    if [ -z "$_profile" ]; then
        echo "Usage: aws-sso-profile [-S|--sso <sso-instance>] <profile>"
        return 1
    fi

    # Build and execute the eval command with optional SSO flag
    if [ -n "$_sso" ]; then
        eval $(/opt/homebrew/bin/aws-sso ${=_args} -S "$_sso" eval -p "$_profile")
    else
        eval $(/opt/homebrew/bin/aws-sso ${=_args} eval -p "$_profile")
    fi
    
    if [ "$AWS_SSO_PROFILE" != "$_profile" ]; then
        return 1
    fi
}

aws-sso-clear() {
    local _args=${AWS_SSO_HELPER_ARGS:- -L error}
    if [ -z "$AWS_SSO_PROFILE" ]; then
        echo "AWS_SSO_PROFILE is not set"
        return 1
    fi
    eval $(/opt/homebrew/bin/aws-sso ${=_args} eval -c)
}

compdef __aws_sso_profile_complete aws-sso-profile
complete -C /opt/homebrew/bin/aws-sso aws-sso

# END_AWS_SSO_CLI

# bun completions
[ -s "/Users/letiesperon/.bun/_bun" ] && source "/Users/letiesperon/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Pull/fetch all repos in ~/Desktop/Projects in parallel
pullall() {
  setopt local_options no_monitor
  local projects_dir="$HOME/Desktop/Projects"
  local tmpdir
  tmpdir=$(mktemp -d)
  local green=$'\033[0;32m' yellow=$'\033[0;33m' red=$'\033[0;31m' reset=$'\033[0m'

  for dir in "$projects_dir"/*/; do
    [[ -d "$dir/.git" ]] || continue
    (
      local name branch current out
      name=$(basename "$dir")

      branch=$(git -C "$dir" symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')
      if [[ -z "$branch" ]]; then
        if git -C "$dir" show-ref --verify --quiet refs/heads/main; then
          branch="main"
        elif git -C "$dir" show-ref --verify --quiet refs/heads/master; then
          branch="master"
        else
          printf "${red}✗${reset} %-28s no default branch\n" "$name" > "$tmpdir/$name"
          return
        fi
      fi

      current=$(git -C "$dir" branch --show-current 2>/dev/null)

      if [[ "$current" == "$branch" ]]; then
        # On the default branch: pull
        out=$(git -C "$dir" pull --ff-only --quiet origin "$branch" 2>&1)
        if [[ $? -eq 0 ]]; then
          printf "${green}✓${reset} %-28s updated ($branch)\n" "$name" > "$tmpdir/$name"
        else
          printf "${yellow}~${reset} %-28s local changes block pull ($branch)\n" "$name" > "$tmpdir/$name"
        fi
      else
        # On a feature branch: update local default branch ref directly without switching
        out=$(git -C "$dir" fetch origin "${branch}:${branch}" --quiet 2>&1)
        if [[ $? -eq 0 ]]; then
          printf "${green}✓${reset} %-28s updated ($branch)\n" "$name" > "$tmpdir/$name"
        else
          out=$(git -C "$dir" fetch origin "$branch" --quiet 2>&1)
          if [[ $? -ne 0 ]]; then
            printf "${red}✗${reset} %-28s $out\n" "$name" > "$tmpdir/$name"
          else
            printf "${yellow}~${reset} %-28s $branch diverged from origin, manual merge needed\n" "$name" > "$tmpdir/$name"
          fi
        fi
      fi
    ) &
  done

  wait
  for f in $(ls "$tmpdir" | sort); do cat "$tmpdir/$f"; done
  rm -rf "$tmpdir"
}

# Socket Firewall — route package managers through sfw
if command -v sfw >/dev/null 2>&1; then
  npm()   { sfw npm   "$@"; }
  yarn()  { sfw yarn  "$@"; }
  pnpm()  { sfw pnpm  "$@"; }
  pip()   { sfw pip   "$@"; }
  pip3()  { sfw pip3  "$@"; }
  uv()    { sfw uv    "$@"; }
  cargo() { sfw cargo "$@"; }
fi
