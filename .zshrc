# Completion
autoload -Uz compinit
compinit

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS

# Prompt
setopt PROMPT_SUBST

git_prompt() {
  local ref dirty

  ref=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null) ||
    ref=$(command git rev-parse --short HEAD 2>/dev/null) ||
    return

  # Prevent branch names from being interpreted as prompt escapes.
  ref=${ref//\%/%%}

  if [[ -n $(command git status --porcelain --ignore-submodules=dirty 2>/dev/null) ]]; then
    dirty='%F{magenta}*%f'
  fi

  print -r -- " %F{white}${ref}%f${dirty}"
}

PROMPT='$(scutil --get LocalHostName 2>/dev/null || echo ${HOST%%.*}):%~$(git_prompt) %(!.#.$) '
RPROMPT='%(?..%F{red}%? ↵%f)'

# Development environment manager
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi
