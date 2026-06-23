class Yo < Formula
  desc "LLM command assistant for your shell"
  homepage "https://github.com/martona/yo"
  version "0.2.0"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/martona/yo/releases/download/v0.2.0/yo-macos-arm64.zip"
      sha256 "4d686176be4526675225d2569f3845f7222df19bfa3bc623f00422e7568c1602"
    end

    on_intel do
      url "https://github.com/martona/yo/releases/download/v0.2.0/yo-macos-amd64.zip"
      sha256 "1ca2be9240a410dd6a4d437911ebee241a651cf1127988786bbf9359f5c206a2"
    end
  end

  def install
    bin.install "yo"
    doc.install "README.md"
    pkgshare.install "LICENSE", "NOTICE", "third-party-licenses"
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
