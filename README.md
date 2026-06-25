# Martona Homebrew Tap

Homebrew formulae and casks for martona macOS software.

## Install

```sh
brew tap martona/tap
```

### yo — CLI (formula)

```sh
brew install martona/tap/yo
yo --setup
```

Installs the signed, notarized macOS release binary from
[`martona/yo`](https://github.com/martona/yo).

### Clipp — menu-bar app (cask)

```sh
brew install --cask martona/tap/clipp
```

Installs the signed, notarized `clipp.app` into Applications and links the bundled `clipp`
CLI (`clipp copy` / `clipp paste` / `clipp ls`) onto your PATH — the GUI and the CLI are the
same binary. Launch Clipp once to create or join a group (shared name + passphrase).

Apple Silicon only (the macOS build is arm64). See
[`martona/clipp`](https://github.com/martona/clipp).
