# dotfiles

A set of hidden plain-text configuration files.

## Setup

This setup targets Apple silicon macOS and expects
[Homebrew](https://brew.sh/) at `/opt/homebrew`. After obtaining the checkout,
tap Moshi's repository and explicitly trust only its required formula:

```sh
brew tap rjyo/moshi
brew trust --formula rjyo/moshi/moshi-hook
```

Then run setup from the repository root:

```sh
script/setup
```

Setup preflights every managed destination before making changes, accepts
existing links that resolve to the intended sources, and never replaces a
conflict. If preflight fails, it makes no changes. A later filesystem,
Homebrew, or preference failure may leave safe partial progress; resolve the
failure and rerun setup.

TextMate may remain open when its folders-first preference is already enabled.
If setup needs to change that preference, quit TextMate and rerun it.

Store the machine's Git author identity outside the repository:

```sh
git config --file "$HOME/.gitconfig.local" user.name "Your Name"
git config --file "$HOME/.gitconfig.local" user.email "you@example.com"
chmod 600 "$HOME/.gitconfig.local"
```

## Validation

Run this repository check before committing changes:

```sh
script/check
```

Checks setup behavior, repository whitespace, sensitive filenames, secret
patterns, final newlines, [zsh](https://github.com/zsh-users/zsh) syntax and
environment, Herdr and Moshi configuration, TextMate property lists, and macOS
ignore patterns.

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

Setup installs missing formulae and casks using `brew bundle --no-upgrade`,
skipping upgrades of already-installed Brewfile entries. Installing missing
packages may still update required dependencies. See the
[Homebrew Bundle documentation](https://docs.brew.sh/Brew-Bundle-and-Brewfile)
and [tap trust documentation](https://docs.brew.sh/Tap-Trust).

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

For routine maintenance, audit the machine and refresh Homebrew metadata:

```sh
script/doctor && brew update
```

Run `brew upgrade` separately when ready to install available updates.

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

Normalize the local SSH permissions expected by `script/doctor`:

```sh
chmod 700 "$HOME/.ssh"
chmod 600 "$HOME/.ssh/config"
chmod 644 "$HOME/.ssh/op_authentication.pub"
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

## [Herdr](https://herdr.dev/)

Use one workspace per active repository and keep its persistent tabs minimal:

- `agent` — primary development session.
- `shell` — Git operations and commands run manually.

Prefer native
[subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents) via
`agents` for routine delegated work.

## [Moshi](https://getmoshi.app/)

When working in this repository, use an optional `moshi` tab to run
[Moshi Desktop](https://getmoshi.app/desktop) without opening its local web
client at `http://127.0.0.1:24544` in a browser:

```sh
moshi --no-open
```

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
