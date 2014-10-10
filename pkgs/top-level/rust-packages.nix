# This file defines the source of Rust / cargo's crates registry
#
# buildRustPackage will automatically download dependencies from the registry
# version that we define here. If you're having problems downloading / finding
# a Rust library, try updating this to a newer commit.

{ fetchgit }:

fetchgit {
  url = git://github.com/rust-lang/crates.io-index.git;

  # 2015-04-20
  rev = "c7112fed5f973e438bb600946016c5083e66b1c9";
  sha256 = "0vyrz7d6zvh79hx5fg557g93r9qm40wx1g4hx7304lina4smk30h";

  # cargo needs the 'master' branch to exist
  leaveDotGit = true;
  branchName = "master";
}
