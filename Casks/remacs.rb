cask "remacs" do
  version "0.1.0-alpha.2"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  url "https://github.com/MakhnoGK/remacs/releases/download/v#{version}/remacs-#{version}-arm64-macos.zip"
  name "Remacs"
  desc "Emacs-inspired IDE, written in Rust"
  homepage "https://github.com/MakhnoGK/remacs"

  livecheck do
    url "https://github.com/MakhnoGK/remacs.git"
    regex(/^v?(\d+(?:\.\d+)+(?:-(?:alpha|beta|rc)\.\d+)?)$/i)
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Remacs.app"
  # Starts remacs apart from the terminal, so that closing its tab does not quit it.
  binary "#{appdir}/Remacs.app/Contents/Resources/launcher", target: "remacs"

  # Not notarized: macOS kills a quarantined copy, and every upgrade downloads one.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Remacs.app"]
  end
end
