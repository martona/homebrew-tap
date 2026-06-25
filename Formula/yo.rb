class Yo < Formula
  desc "LLM command assistant for your shell"
  homepage "https://github.com/martona/yo"
  version "0.2.2"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/martona/yo/releases/download/v0.2.2/yo-macos-arm64.zip"
      sha256 "d7efa67e60c44ca3748c4a05f36198872f61a57d29586d44093cc9758c8dccac"
    end

    on_intel do
      url "https://github.com/martona/yo/releases/download/v0.2.2/yo-macos-amd64.zip"
      sha256 "ea118563ad578c5bbb515eb92395b68d18598555967da98fadc0cdf2d77fcf1d"
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
