local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

PROMPT='$(scutil --get LocalHostName 2>/dev/null || echo ${HOST%%.*}):%~$(git_prompt_info) %(!.#.$) '

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[magenta]%}*%{$fg[white]%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}"

RPS1='${return_code}'