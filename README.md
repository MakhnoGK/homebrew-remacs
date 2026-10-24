# Homebrew tap for remacs

[remacs](https://github.com/MakhnoGK/remacs), an Emacs-inspired IDE for macOS 14+ on
Apple Silicon:

```sh
brew install makhnogk/remacs/remacs
```

`remacs [path]` starts it; `brew info remacs` says how to add it to Launchpad.
`brew install --HEAD makhnogk/remacs/remacs` builds the `dev` branch instead of the latest
release (needs Xcode).

## Publishing a release

1. `brew bump-formula-pr --url <the tag's tar.gz> makhnogk/remacs/remacs` opens a pull
   request; CI builds the bottle.
2. When it is green, run the `brew pr-pull` workflow with the pull request's number: it
   uploads the bottle to this repository's releases and pushes the bottle block to `main`.
