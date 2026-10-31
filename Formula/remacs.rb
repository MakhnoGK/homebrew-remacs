class Remacs < Formula
  desc "Emacs-inspired IDE, written in Rust"
  homepage "https://github.com/MakhnoGK/remacs"
  url "https://github.com/MakhnoGK/remacs/releases/download/v0.1.0-alpha.5/remacs-0.1.0-alpha.5.tar.gz"
  sha256 "7d314b1e059ca1678e65c5d9ef9b2d70f468189eb420f9dfe4b914c3ce9ab87f"
  # Apache-2.0 with the Commons Clause, which SPDX has no identifier for.
  license :cannot_represent
  head "https://github.com/MakhnoGK/remacs.git", branch: "dev"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-(?:alpha|beta|rc)\.\d+)?)$/i)
  end

  bottle do
    root_url "https://github.com/MakhnoGK/homebrew-remacs/releases/download/remacs-0.1.0-alpha.4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b0c839dc2e0f604eed3bef247cf831124860858a670375df867e734387b0a2d"
    sha256 cellar: :any,                 x86_64_linux:  "e000ac9681f9783ed1dc309e599a8377e4231ec1ac672da8c4b198f9b843e524"
  end

  depends_on "cargo-about" => :build
  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_macos do
    # gpui compiles its Metal shaders at build time.
    depends_on xcode: :build
    depends_on arch: :arm64
    # remacs runs on 14, but Homebrew no longer bottles rust there.
    depends_on macos: :sequoia
  end

  # Wayland, Vulkan and fontconfig are the desktop's, loaded when remacs starts.
  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libxcb"
    depends_on "libxkbcommon"
  end

  def install
    # A source archive has no git history to read the version from.
    unless build.head?
      ENV["REMACS_VERSION"] = version.to_s
      ENV["REMACS_COMMIT"] = "homebrew"
    end
    # The license notices read every crate in the lock file offline, not only those built.
    system "cargo", "fetch", "--locked"
    system "cargo", "xtask", "bundle"

    if OS.linux?
      # Laid out as a prefix: bin/remacs, lib/remacs, the menu entry and icons in share.
      bundle = Pathname.glob("target/bundle/remacs-*-linux").first
      rm bundle/"install.sh"
      # The desktop's session may not have Homebrew's bin on its PATH.
      inreplace bundle/"share/applications/io.github.makhnogk.remacs.desktop",
                /^Exec=remacs /, "Exec=#{opt_lib}/remacs/remacs "
      prefix.install bundle.children
      return
    end

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
    if OS.linux?
      return <<~EOS
        `remacs [path]` starts it from a terminal. To have Remacs in the applications menu,
        add Homebrew's share to your session's XDG_DATA_DIRS and log in again:
          mkdir -p ~/.config/environment.d
          echo 'XDG_DATA_DIRS=#{HOMEBREW_PREFIX}/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}' \\
            > ~/.config/environment.d/homebrew-share.conf
      EOS
    end

    <<~EOS
      `remacs [path]` starts it from a terminal. To have Remacs in Launchpad and Spotlight,
      install the cask instead, which puts it in /Applications:
        brew uninstall --formula remacs
        brew trust --cask makhnogk/remacs/remacs
        brew install --cask makhnogk/remacs/remacs
    EOS
  end

  test do
    # A head build names itself by `git describe`, not by Homebrew's HEAD-<commit>.
    assert_match version.head? ? "remacs" : version.to_s, shell_output("#{bin}/remacs --version")
  end
end
