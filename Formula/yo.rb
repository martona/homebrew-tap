class Yo < Formula
  desc "LLM command assistant for your shell"
  homepage "https://github.com/martona/yo"
  version "0.3.4"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on :macos

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

  def install
    bin.install "yo"
    doc.install "README.md"
    pkgshare.install "LICENSE", "NOTICE", "THIRD-PARTY-LICENSES.txt"
  end

  def caveats
    <<~EOS
      Run setup once after install:
        yo --setup

      Or add the zsh integration manually:
        if command -v yo >/dev/null 2>&1; then eval "$(yo --init zsh)"; fi
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yo --version")
  end
end
