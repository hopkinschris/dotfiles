# Prevent duplicate PATH entries
typeset -U PATH path

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Default text editor
export EDITOR="mate -w"
export VISUAL="$EDITOR"

# User-installed commands
export PATH="$HOME/.local/bin:$PATH"

# Mise shims
# https://mise.jdx.dev/dev-tools/shims.html
export PATH="$HOME/.local/share/mise/shims:$PATH"
