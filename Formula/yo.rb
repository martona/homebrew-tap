class Yo < Formula
  desc "LLM command assistant for your shell"
  homepage "https://github.com/martona/yo"
  version "0.3.3"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/martona/yo/releases/download/v0.3.3/yo-macos-arm64.zip"
      sha256 "6d8b4808852c03ee4a68ab0e578e8deff60e3f46d5d64b113dfce631f97dc399"
    end

    on_intel do
      url "https://github.com/martona/yo/releases/download/v0.3.3/yo-macos-amd64.zip"
      sha256 "e438cb31e5da26ca94c25a446aadc56f9f369a287b05acabe88d1ae1042cb125"
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
