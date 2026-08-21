# dotfiles

A set of hidden plain-text configuration files.

## Setup

This setup targets Apple silicon macOS and expects
[Homebrew](https://brew.sh/) at `/opt/homebrew`. From the repository root,
create the required directories and symlinks. Existing symlink destinations
are skipped:

```zsh
mkdir -p \
  "$HOME/.config/ghostty" \
  "$HOME/.config/herdr" \
  "$HOME/.config/moshi" \
  "$HOME/Library/Application Support/TextMate/Pristine Copy/Bundles"

link_file() {
  local source=$1
  local destination=$2

  if [[ -e "$destination" || -L "$destination" ]]; then
    printf 'Skipping existing: %s\n' "$destination"
  else
    ln -s "$source" "$destination"
  fi
}

link_file "$PWD/.Brewfile" "$HOME/.Brewfile"
link_file "$PWD/.gitconfig" "$HOME/.gitconfig"
link_file "$PWD/.gitignore" "$HOME/.gitignore"
link_file "$PWD/.tm_properties" "$HOME/.tm_properties"
link_file "$PWD/.zprofile" "$HOME/.zprofile"
link_file "$PWD/.zshrc" "$HOME/.zshrc"
link_file "$PWD/.config/ghostty/config.ghostty" \
  "$HOME/.config/ghostty/config.ghostty"
link_file "$PWD/.config/herdr/config.toml" \
  "$HOME/.config/herdr/config.toml"
link_file "$PWD/.config/moshi/config.toml" \
  "$HOME/.config/moshi/config.toml"
link_file "$PWD/.config/textmate/Dotfiles.tmbundle" \
  "$HOME/Library/Application Support/TextMate/Pristine Copy/Bundles/Dotfiles.tmbundle"

unfunction link_file
```

To show folders first in TextMate's project browser, close TextMate and run:

```sh
defaults write com.macromates.TextMate foldersOnTop -bool true
```

## Validation

Run this repository check before committing changes:

```sh
script/check
```

Checks repository whitespace and final newlines,
[zsh](https://github.com/zsh-users/zsh) syntax and environment, Herdr and
Moshi configuration, TextMate property lists, and macOS ignore patterns.

## [Homebrew](https://brew.sh/)

Before the first bundle run, tap and trust Moshi's third-party repository:

```sh
brew tap rjyo/moshi
brew trust rjyo/moshi
```

Then install the declared formulae and casks from the symlinked `.Brewfile`:

```sh
brew bundle --global
```

The `textmate` cask also links its `mate` command into
[Homebrew](https://brew.sh/)'s binary directory.

Afterwards, enable
`Settings > Developer > Integrate with 1Password CLI` in `1Password.app`.

In Tailscale, add its command-line integration from Settings. This installs
`/usr/local/bin/tailscale`; no shell configuration is required.

## [Moshi](https://getmoshi.app/)

Enable `System Settings > General > Sharing > Remote Login` and keep Tailscale
SSH disabled. Then pair the host from Moshi:

```sh
moshi-hook host setup
```

To enable agent integration, copy the token from `Moshi > Settings > Hooks` and
run:

```zsh
read -rs "MOSHI_TOKEN?Moshi Hooks token: "; echo
moshi-hook pair --token "$MOSHI_TOKEN"
unset MOSHI_TOKEN
moshi-hook install
brew services start moshi-hook
moshi-hook status
```

`moshi-hook install` registers Codex lifecycle hooks in
`~/.codex/hooks.json`. In Codex—including when launched through Herdr—run
`/hooks`, verify that the Moshi hooks execute
`/opt/homebrew/bin/moshi-hook codex-hook`, and trust them. Until trusted, Codex
skips the hooks, so Moshi agent status and hook-driven notifications will not
update.

## Notes

- Native Zsh is used without a shell framework. `.zprofile` defines the login
environment and a unique `PATH`; `.zshrc` provides completion, history,
[mise](https://github.com/jdx/mise), and a prompt with Git and exit status.
- Git uses the shared macOS ignore file, `master` as the initial branch, and
TextMate's `mate -w` command as its editor.
- `.editorconfig` defines shared editor behavior while `.gitattributes`
normalizes text to LF. `.gitignore` is exempt because its macOS filename
patterns contain intentional carriage returns.
- [ChatGPT Classic](https://formulae.brew.sh/cask/chatgpt-classic) is installed
through [Homebrew](https://brew.sh/) as the previous standalone desktop client;
its application state remains separate from the `codex` cask and `~/.codex`.
- [Ghostty](https://github.com/ghostty-org/ghostty) reads its tracked
configuration from `~/.config/ghostty/config.ghostty` and uses the bundled
[Vercel theme](https://github.com/mbadolato/iTerm2-Color-Schemes#vercel). Its
terminal font is
[Geist Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/GeistMono).
- [Google Chrome](https://formulae.brew.sh/cask/google-chrome) is installed
through [Homebrew](https://brew.sh/); profiles and browser data remain outside
this repository.
- [Herdr](https://github.com/herdrdev/herdr) reads its tracked configuration
from `~/.config/herdr/config.toml`, groups agents by workspace, and skips
first-run onboarding.
- [Moshi](https://getmoshi.app/) reads its tracked configuration from
`~/.config/moshi/config.toml` and uses the Homebrew-installed `mosh` and
`moshi-hook` formulae. Its appearance uses the
[Vercel theme](https://getmoshi.app/themes/vercel) with an imported
[Geist Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/GeistMono).
These preferences, Remote Login, pairing state, and SSH keys remain outside
this repository.
- [Little Snitch](https://formulae.brew.sh/cask/little-snitch) is
installed through [Homebrew](https://brew.sh); its rules, traffic history,
license, and network-extension approval remain outside this repository.
- [Tailscale](https://formulae.brew.sh/cask/tailscale-app) is installed through
[Homebrew](https://brew.sh/) using its standalone macOS app; authentication and
tailnet configuration remain outside this repository.
- [TextMate](https://github.com/textmate/textmate) reads `.tm_properties` and
uses plain Geist Mono with the tracked
[Dracula](https://github.com/dracula/textmate) theme. The
[EditorConfig–TextMate Plugin](https://github.com/Mr0grog/editorconfig-textmate)
applies `.editorconfig` over overlapping TextMate settings.
- Credentials are managed via [1Password](https://1password.com/) and remain
outside this repository.
