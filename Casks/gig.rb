cask "gig" do
  version "0.2.0.4"
  sha256 "5b4abb9815a9d179c143ec91ebaa8ed41c9e12772a384864e2960be65892d4b5"

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
