# Homebrew tap for remacs

[remacs](https://github.com/MakhnoGK/remacs), an Emacs-inspired IDE. On macOS 14+ on
Apple Silicon, the cask installs the release's app into /Applications, where Launchpad and
Spotlight find it, and removes macOS's quarantine from it, as it is not notarized:

```sh
brew install --cask makhnogk/remacs/remacs
```

The formula builds it instead, on macOS 15+ (from a bottle) and Linux (bottled for
x86_64); it and the cask both link `remacs`, so install one of the two:

```sh
brew install makhnogk/remacs/remacs
```

`remacs [path]` starts it; on Linux, `brew info remacs` says how to add it to the
applications menu. `brew install --HEAD makhnogk/remacs/remacs` builds the `dev`
branch instead of the latest release (needs Xcode on macOS).

## Publishing a release

Automatic: remacs's release workflow opens a `bump-remacs-<version>` pull request with
the release's source archive; test-bot builds the macOS and Linux bottles on it, and
`auto-publish` then runs `brew pr-pull`, which uploads them to this repository's releases
and pushes the formula with its bottle block to `main`.

By hand, if a step fails: `brew bump-formula-pr --url <the release's tar.gz>
makhnogk/remacs/remacs`, then run the `brew pr-pull` workflow with the pull request's
number once it is green.

The cask: remacs's `macos-app` workflow adds `remacs-<version>-arm64-macos.zip` to the
release and opens a `cask-remacs-<version>` pull request with its SHA-256, merged by
hand. By hand: run that workflow with the version.
