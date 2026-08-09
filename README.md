# dotfiles

Personal macOS configuration managed as symlinks from this repository.

## Setup

This setup targets Apple silicon macOS and expects Homebrew at
`/opt/homebrew`. From the repository root, create the required directories and
symlinks:

```zsh
mkdir -p \
  "$HOME/.config/ghostty" \
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
link_file "$PWD/.config/textmate/Dotfiles.tmbundle" \
  "$HOME/Library/Application Support/TextMate/Pristine Copy/Bundles/Dotfiles.tmbundle"

unfunction link_file

defaults write com.macromates.TextMate foldersOnTop -bool true
```

Run the TextMate preference command while TextMate is closed. Existing
destinations are skipped.

## Validation

Run this repository check before committing changes:

```sh
script/check
```

Checks repository whitespace and final newlines,
[zsh](https://github.com/zsh-users/zsh) syntax and environment, TextMate
property lists, and macOS ignore patterns.

## Homebrew

Install the declared formulae and casks from the symlinked `.Brewfile`:

```sh
brew bundle --global
```

The TextMate cask also links its `mate` command into Homebrew's binary
directory.

## Notes

- Native Zsh is used without a shell framework. `.zprofile` defines the login
environment and a unique `PATH`; `.zshrc` provides completion, history,
[mise](https://github.com/jdx/mise), and a prompt with Git and exit status.
- Git uses the shared macOS ignore file, `master` as the initial branch, and
TextMate's `mate -w` command as its editor.
- `.editorconfig` defines shared editor behavior while `.gitattributes`
normalizes text to LF. `.gitignore` is exempt because its macOS filename
patterns contain intentional carriage returns.
- [Hermes Agent](https://github.com/NousResearch/hermes-agent) commands are
installed in `~/.local/bin`; its configuration and data remain in `~/.hermes`,
outside this repository.
- [Ghostty](https://github.com/ghostty-org/ghostty) reads its tracked
configuration from `~/.config/ghostty/config.ghostty` and uses the Vercel theme
with the Geist Mono Nerd Font variant for terminal glyphs.
- [TextMate](https://github.com/textmate/textmate) reads `.tm_properties` and
uses plain Geist Mono with the tracked
[Dracula](https://github.com/dracula/textmate) theme. The
[EditorConfig–TextMate Plugin](https://github.com/Mr0grog/editorconfig-textmate)
applies `.editorconfig` over overlapping TextMate settings.
- Credentials are managed via [1Password](https://github.com/1password) and are
not stored in this repository.
