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

Store the machine's Git author identity outside the repository:

```sh
git config --file "$HOME/.gitconfig.local" user.name "Your Name"
git config --file "$HOME/.gitconfig.local" user.email "you@example.com"
chmod 600 "$HOME/.gitconfig.local"
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

Checks repository whitespace, sensitive filenames, secret patterns, and final
newlines, [zsh](https://github.com/zsh-users/zsh) syntax and environment, Herdr
and Moshi configuration, TextMate property lists, and macOS ignore patterns.

Audit the local machine against the documented setup with:

```sh
script/doctor
```

Pass `--network` to also verify GitHub SSH authentication and repository
access:

```sh
script/doctor --network
```

The doctor is read-only. UI-only checks are reported and require separate verification.

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

After completion:

- In ChatGPT, install
[Chrome](https://learn.chatgpt.com/docs/chrome-extension) from `Plugins` and
approve the requested access. Manage the connection and website permissions
under `Computer use`.
- In Tailscale, add its command-line integration from Settings. This installs
`/usr/local/bin/tailscale`; no shell configuration is required.
- The `textmate` cask also links its `mate` command into
[Homebrew](https://brew.sh/)'s binary directory.
- Before signing in to Codex, add `cli_auth_credentials_store = "keyring"` at
the top level of `~/.codex/config.toml`. This keeps credentials in Keychain and
`~/.codex/auth.json` absent.

## [1Password](https://1password.com/)

### CLI

Access 1Password from the terminal to load secrets, manage items, and more.

Enable `Settings > Developer > Integrate with 1Password CLI`.

### SSH Agent

Manage your SSH keys, sign Git commits, and authorize SSH connections.

For GitHub SSH access, follow
[1Password's SSH guide](https://www.1password.dev/ssh/get-started):

- Generate an Ed25519 key named `Authentication Key` in the Private vault and
  register it with GitHub as an authentication key whose title is the output
  of `scutil --get ComputerName`.
- Download its public key to `~/.ssh/op_authentication.pub` and enable the
  1Password SSH Agent. Display key names in authorization prompts and open SSH
  URLs with Ghostty.
- Decline 1Password's automatic SSH configuration edit, which targets
  `Host *`, and configure only GitHub to use the agent:

```sshconfig
Host github.com
  HostName github.com
  User git
  IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  IdentityFile ~/.ssh/op_authentication.pub
  IdentitiesOnly yes
```

The private key remains in 1Password; the local identity file is only the
public-key selector described in
[1Password's advanced SSH configuration](https://www.1password.dev/ssh/agent/advanced).
Verify the setup with:

```sh
ssh -T git@github.com
git ls-remote origin HEAD
```

On first use, authorize Herdr with Touch ID and leave approval for all
applications disabled.

After removing obsolete local private keys, enable
`Settings > Developer > Watchtower > SSH keys`.

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

Background Codex usage collection is enabled in the tracked Moshi
configuration. Verify the setting and send a test snapshot to Moshi with:

```sh
moshi-hook set usage-collection
moshi-hook usage --sync
```

After changing this setting, restart the daemon with
`brew services restart moshi-hook`.

## Notes

- Native Zsh is used without a shell framework. `.zprofile` defines the login
environment and a unique `PATH`; `.zshrc` provides completion, history,
[mise](https://github.com/jdx/mise), and a prompt with Git and exit status.
- Git uses the shared macOS ignore file, `master` as the initial branch, and
TextMate's `mate -w` command as its editor.
- `.editorconfig` defines shared editor behavior while `.gitattributes`
normalizes text to LF. `.gitignore` is exempt because its macOS filename
patterns contain intentional carriage returns.
- [ChatGPT](https://formulae.brew.sh/cask/chatgpt) is installed through
[Homebrew](https://brew.sh/) for Chrome extension support. Its Codex features
share state under `~/.codex` with the `codex` cask.
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
