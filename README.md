# Homebrew tap for remacs

[remacs](https://github.com/MakhnoGK/remacs), an Emacs-inspired IDE, for macOS 15+ on
Apple Silicon (on macOS 14, build it from source as its README says):

```sh
brew install makhnogk/remacs/remacs
```

`remacs [path]` starts it; `brew info remacs` says how to add it to Launchpad.
`brew install --HEAD makhnogk/remacs/remacs` builds the `dev` branch instead of the latest
release (needs Xcode).

## Publishing a release

Automatic: remacs's release workflow opens a `bump-remacs-<version>` pull request with
the release's source archive; test-bot builds the bottle on it, and `auto-publish` then
runs `brew pr-pull`, which uploads the bottle to this repository's releases and pushes
the formula with its bottle block to `main`.

By hand, if a step fails: `brew bump-formula-pr --url <the release's tar.gz>
makhnogk/remacs/remacs`, then run the `brew pr-pull` workflow with the pull request's
number once it is green.
