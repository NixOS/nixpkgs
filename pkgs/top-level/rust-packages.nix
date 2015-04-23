# This file defines the source of Rust / cargo's crates registry
#
# buildRustPackage will automatically download dependencies from the registry
# version that we define here. If you're having problems downloading / finding
# a Rust library, try updating this to a newer commit.

{ runCommand, fetchgit, git }:

let
  version = "2015-04-23";

  src = fetchgit {
      url = git://github.com/rust-lang/crates.io-index.git;

      rev = "965b634156cc5c6f10c7a458392bfd6f27436e7e";
      sha256 = "1hbl3g1d6yz6x2fm76dxmcn8rdrmri4l9n6flvv0pkn4hsid7zw1";

      # cargo needs the 'master' branch to exist
      leaveDotGit = true;
      branchName = "master";
  };

in

runCommand "rustRegistry-${version}-${builtins.substring 0 7 src.rev}" {} ''
  # For some reason, cargo doesn't like fetchgit's git repositories, not even
  # if we clone them (tested with registry rev
  # 965b634156cc5c6f10c7a458392bfd6f27436e7e), failing with the message:
  #
  # "Target OID for the reference doesn't exist on the repository"
  #
  # So we'll just have to create a new git repository from scratch with the
  # contents downloaded with fetchgit...

  mkdir -p $out

  cp -r ${src}/* $out/

  cd $out

  git="${git}/bin/git"

  $git init
  $git config --local user.email "example@example.com"
  $git config --local user.name "example"
  $git add .
  $git commit -m 'Rust registry commit'
''
