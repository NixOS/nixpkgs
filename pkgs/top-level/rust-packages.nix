# This file defines the source of Rust / cargo's crates registry
#
# buildRustPackage will automatically download dependencies from the registry
# version that we define here. If you're having problems downloading / finding
# a Rust library, try updating this to a newer commit.

{ runCommand, fetchFromGitHub, git }:

let
<<<<<<< HEAD
  version = "2017-04-13";
  rev = "5758a926a647716bd650978ad53aeb4a0c5f9b45";
  sha256 = "1fnwh62k8fbflciv1qg3r9fsqn1xy72flyv15ii3mpja2vqzkdi2";
=======
  version = "2017-02-13";
  rev = "1e63b42f967d6bb3338526c3570bf81049153702";
  sha256 = "17w79fic6ndb724z7zywm1cisha362bjvs8sbvv740nrvsya41gy";
>>>>>>> d30cd1bce4e54a95bb7d04bb1850e272d3424520

  src = fetchFromGitHub {
      inherit rev;
      inherit sha256;

      owner = "rust-lang";
      repo = "crates.io-index";
  };

in

runCommand "rustRegistry-${version}-${builtins.substring 0 7 rev}" { inherit src; } ''
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
  $git commit --quiet -m 'Rust registry commit'

  touch $out/touch . "$out/.cargo-index-lock"
''
