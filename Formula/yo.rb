class Yo < Formula
  desc "LLM command assistant for your shell"
  homepage "https://github.com/martona/yo"
  version "0.3.4"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  on_macos do
    on_arm do
      url "https://github.com/martona/yo/releases/download/v0.3.4/yo-macos-arm64.zip"
      sha256 "4a081fa6444882c604b17e8eb539f24ad21c929401285241b0b1926ba6b58589"
    end

    on_intel do
      url "https://github.com/martona/yo/releases/download/v0.3.4/yo-macos-amd64.zip"
      sha256 "7e48c602b7f033bca48ea2c97bffa32c02f28f0b6888ef614094249492984f1e"
    end
  end

  on_linux do
    on_arm do
      # Homebrew on Linux/ARM is unsupported upstream; this is best-effort. The yo
      # binary itself is a native, fully-static aarch64 build.
      url "https://github.com/martona/yo/releases/download/v0.3.4/yo-linux-arm64"
      sha256 "76afd8638e61974f4f0f37ebfd1d7c9813908e04501a01d867e303ab737ab865"
    end

    on_intel do
      url "https://github.com/martona/yo/releases/download/v0.3.4/yo-linux-amd64"
      sha256 "087f1016bbce550d173c89fc06976185fda5bd4ac3a1756dc8fe68fee84a7c4b"
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
