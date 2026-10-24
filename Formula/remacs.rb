class Remacs < Formula
  desc "Emacs-inspired IDE for macOS, written in Rust"
  homepage "https://github.com/MakhnoGK/remacs"
  url "https://github.com/MakhnoGK/remacs/archive/refs/tags/v0.1.0-alpha.1.tar.gz"
  sha256 "9b9b66e56b75cacb2ba3766525321bd29f4ce2ac72345fdac9aa256607dc0bc2"
  # Apache-2.0 with the Commons Clause, which SPDX has no identifier for.
  license :cannot_represent
  head "https://github.com/MakhnoGK/remacs.git", branch: "dev"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-(?:alpha|beta|rc)\.\d+)?)$/i)
  end

  depends_on "cargo-about" => :build
  depends_on "cmake" => :build
  depends_on "rust" => :build
  # gpui compiles its Metal shaders at build time.
  depends_on xcode: :build
  depends_on arch: :arm64
  # remacs runs on 14, but Homebrew no longer bottles rust there.
  depends_on macos: :sequoia

  def install
    # A source archive has no git history to read the version from.
    unless build.head?
      ENV["REMACS_VERSION"] = version.to_s
      ENV["REMACS_COMMIT"] = "homebrew"
    end
    # The license notices read every crate in the lock file offline, not only those built.
    system "cargo", "fetch", "--locked"
    system "cargo", "xtask", "bundle"
    prefix.install "target/bundle/Remacs.app"

    # Detached from the terminal, so closing its tab does not quit remacs.
    binary = opt_prefix/"Remacs.app/Contents/MacOS/remacs"
    (bin/"remacs").write <<~SH
      #!/bin/sh
      [ "$1" = --version ] && exec '#{binary}' --version
      nohup '#{binary}' "$@" </dev/null >/dev/null 2>&1 &
    SH
  end

  def caveats
    <<~EOS
      `remacs [path]` starts it from a terminal. To have Remacs in Launchpad and Spotlight:
        osascript -e 'tell application "Finder" to make alias file to posix file "#{opt_prefix}/Remacs.app" at posix file "/Applications" with properties {name:"Remacs.app"}'
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/remacs --version")
  end
end
