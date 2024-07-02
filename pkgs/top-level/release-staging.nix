/*
A release file that builds few packages.

The aim is to test the `staging` branch before it is merged into `staging-next` at which points more builds are run.

*/


{ nixpkgs ? { outPath = (import ../../lib).cleanSource ../..; revCount = 1234; shortRev = "abcdef"; }
, supportedSystems ? [ "x86_64-linux" "x86_64-darwin" ]
}:

with import ./release-lib.nix { inherit supportedSystems; };


(import ./release-small.nix {inherit nixpkgs; inherit supportedSystems;}) // (mapTestOn (rec {

  # Some tools
  diffoscope = all;
  emacs = all;
  git = all;
  nox = all;
  vim = all;

  llvm = all;

  linuxPackages.kernel = linux;

  ## Package sets - Here a certain package is chosen simply to test the package set logic

  # Erlang
  erlang = all;

  # Gnome 3
  gnome3.gnome-system-monitor = linux;

  # Go
  go = all;

  # Haskell
  ghc = all;
  pandoc = all;

  # KDE
  systemsettings = linux;

  # Perl
  exiftool = all;

  # Python
  python2Packages.pytest = all;
  python3Packages.pytest = all;

  # Node
  npm2nix = all;

  # Rust
  cargo = all;

  # Ocaml
  unison = all;

  # Ruby
  bundix = all;
  bundler = all;
  ruby = all;

  # Qt5
  calibre = all;

}))
