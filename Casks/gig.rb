cask "gig" do
  version "0.1.0.2"
  sha256 "4c8c808e177d43d3d4b79e4a67f0cbbe835bede60aba4956ac80e3c134220999"

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
