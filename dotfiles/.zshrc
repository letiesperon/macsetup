#!/bin/zsh

typeset -U path # Prevent duplicate entries on the $PATH

export ZSH="$HOME/.oh-my-zsh"

eval "$(rbenv init - zsh)"
eval "$(pyenv init -)"

# PATH
path+=$N_PREFIX/bin
path+=$PYENV_ROOT/bin
path=('/opt/homebrew/bin' '/opt/homebrew/sbin' $path) # Ensure Homebrew installed binaries take precedence
export PATH # Export to sub-processes (make it inherited by child processes)

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
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
alias spotify-failed="/Users/letiesperon/.local/bin/spotify-failed"
alias spotify-failed="/Users/letiesperon/.local/bin/spotify-failed"


