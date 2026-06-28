cask "gig" do
  version "0.2.0.5"
  sha256 "7e65009af5b504d92d8cb0d95f44c6bdeb3f59efe7bc11b16177d8ab01f18f8d"

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
