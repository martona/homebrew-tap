class Yo < Formula
  desc "LLM command assistant for your shell"
  homepage "https://github.com/martona/yo"
  version "0.3.5"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  on_macos do
    on_arm do
      url "https://github.com/martona/yo/releases/download/v0.3.5/yo-macos-arm64.zip"
      sha256 "a5b51a464d25c2a5299209fddbf7ba5acca6850cae095d54d998fbce37b28456"
    end

    on_intel do
      url "https://github.com/martona/yo/releases/download/v0.3.5/yo-macos-amd64.zip"
      sha256 "499d06573b262ad39e4f04f63c96d2e04a15c074397b62f6ad7ae4ae584d84bc"
    end
  end

  on_linux do
    on_arm do
      # Homebrew on Linux/ARM is unsupported upstream; this is best-effort. The yo
      # binary itself is a native, fully-static aarch64 build.
      url "https://github.com/martona/yo/releases/download/v0.3.5/yo-linux-arm64"
      sha256 "0c76dd08923777bfc49e3f915ea1eb6cc06e2c728bc3a19020fddefd3e0d7969"
    end

    on_intel do
      url "https://github.com/martona/yo/releases/download/v0.3.5/yo-linux-amd64"
      sha256 "ed08e6363277412a071646796a44daeaa83d68600f793747050858b1ab80f911"
    end
  end

  def install
    if OS.mac?
      # macOS ships a .zip bundling the binary plus license/provenance docs.
      bin.install "yo"
      doc.install "README.md"
      pkgshare.install "LICENSE", "NOTICE", "THIRD-PARTY-LICENSES.txt"
    else
      # Linux ships a bare, statically-linked binary named per-arch. Source and the
      # GPLv3 text live in the upstream repo (see homepage / license).
      arch = Hardware::CPU.arm? ? "arm64" : "amd64"
      bin.install "yo-linux-#{arch}" => "yo"
    end
  end

  def caveats
    <<~EOS
      Run setup once after install:
        yo --setup

      Or add the integration manually to your shell profile (use bash on most
      Linux systems, zsh on macOS):
        if command -v yo >/dev/null 2>&1; then eval "$(yo --init zsh)"; fi
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yo --version")
  end
end
