# dotfiles

A set of hidden plain-text configuration files.

## Validation

Run this repository check before committing changes:

```sh
script/check
```

Checks whitespace, [zsh](https://github.com/zsh-users/zsh) syntax, final
newlines, and macOS ignore patterns.

## Notes

- Project runtimes are managed with [mise](https://github.com/jdx/mise);
[rvm](https://github.com/rvm/rvm) and [nvm](https://github.com/nvm-sh/nvm)
are disabled by default.
- [TextMate](https://macromates.com/) relies on `.tm_properties` for settings;
[EditorConfig–TextMate Plugin](https://github.com/Mr0grog/editorconfig-textmate)
provides `.editorconfig` precedence of shared coding styles.
- Credentials are managed via [1Password](https://github.com/1password) and are
not stored in this repository.
