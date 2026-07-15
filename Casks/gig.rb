cask "gig" do
  version "0.2.0.6"
  sha256 "71be5793e213c1b5ab4d27bd92c8804b5ba8c15c902aede9cf32f3ad7dc41411"

  url "https://github.com/martona/gig/releases/download/v#{version}/gig-macos-arm64.zip",
      verified: "github.com/martona/gig/"
  name "gig"
  desc "Multi-camera viewer for Frigate NVR"
  homepage "https://github.com/martona/gig"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "gig.app"

  zap trash: [
    "~/Library/Caches/stream.gig.app",
    "~/Library/Preferences/stream.gig.app.plist",
    "~/Library/Saved Application State/stream.gig.app.savedState",
  ]

end
