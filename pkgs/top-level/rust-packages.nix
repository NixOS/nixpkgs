# This file defines the source of Rust / cargo's crates registry
#
# buildRustPackage will automatically download dependencies from the registry
# version that we define here. If you're having problems downloading / finding
# a Rust library, try updating this to a newer commit.

{ runCommand, fetchgit, git }:

let
  version = "2015-05-12";

  src = fetchgit {
      url = git://github.com/rust-lang/crates.io-index.git;

      rev = "9bf9e7f2b242552ccec879b47b2225a76c7c79b0";
      sha256 = "14rrpm6and52qasn7fv5fkflhnkyr86xy0k9pjgw407k7xms0cmw";
  };

in

runCommand "rustRegistry-${version}-${builtins.substring 0 7 src.rev}" {} ''
  # For some reason, cargo doesn't like fetchgit's git repositories, not even
  # if we set leaveDotGit to true, set the fetchgit branch to 'master' and clone
  # the repository (tested with registry rev
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
