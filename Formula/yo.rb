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
      sha256 "dd2340034571f945bbb93b6453a98a249014ec549b9d4ec5fc475b9e354d4dcc"
    end

    on_intel do
      url "https://github.com/martona/yo/releases/download/v0.2.2/yo-macos-amd64.zip"
      sha256 "cb93bfef318e9cf900afe62b7c266973aaa909503690eaec55a66e3fc89311c6"
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
