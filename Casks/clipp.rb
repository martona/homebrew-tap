cask "clipp" do
  version "1.2.1.123"
  sha256 "da4b4e64360bb0d14e1ad7d474a7957936538640f5039002eb369ada319af5e0"

  url "https://github.com/martona/clipp/releases/download/v#{version}/clipp-macos-arm64.zip",
      verified: "github.com/martona/clipp/"
  name "Clipp"
  desc "Peer-to-peer clipboard sync over your local network"
  homepage "https://clipp.net"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64

  app "clipp.app"
  # The same binary is the menu-bar app and the `clipp` CLI (copy/paste/ls); linking it
  # onto PATH is the supported headless/terminal usage.
  binary "#{appdir}/clipp.app/Contents/MacOS/clipp"

  zap trash: [
    "~/Library/Caches/net.clipp.ios",
    "~/Library/Preferences/net.clipp.ios.plist",
    "~/Library/Saved Application State/net.clipp.ios.savedState",
  ]

  caveats <<~EOS
    Clipp runs as a menu-bar app. Launch it once to create or join a group
    (shared name + passphrase). The bundled `clipp` CLI (copy/paste/ls) is linked
    onto your PATH and shares that configuration.

    The group key lives in your login keychain and is not removed on uninstall.
  EOS
end
