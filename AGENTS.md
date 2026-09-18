# Repository guidance

This repository targets Apple silicon macOS using native Zsh and small,
explicit scripts. See [README.md](README.md) for setup, manual steps, and
machine audits.

- Treat this repository as public. Never add credentials, private keys,
  tokens, or private machine or account state.
- Do not run `script/setup` against the live machine, change real system
  preferences, install software, or perform network checks unless explicitly
  requested. Isolated temporary-`HOME` tests run by `script/check` are allowed.
- Treat `script/lib/links.zsh`, `.Brewfile`, and tracked application
  configurations as their respective sources of truth.
- Preserve conflicting files and keep machine-specific or sensitive state out
  of setup.
- Follow `.editorconfig` and `.gitattributes`; preserve the intentional
  carriage returns in `.gitignore`.
- Run `script/check` before handing off changes or committing, and report any
  failed or skipped checks. Keep behavior and documentation synchronized.
- Prefer deletion and reuse. Use native Zsh, macOS, Git, and Homebrew before
  adding custom code, dependencies, abstractions, or configuration for
  hypothetical needs.
- Choose the smallest clear implementation after understanding the affected
  behavior. Retain conflict safety, validation, error handling, security, and
  focused checks for non-trivial behavior.
