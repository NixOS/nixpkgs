{ callPackage, stdenv, fetchgit, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-03-02";

  src = fetchgit {
    url = git://github.com/zfsonlinux/zfs.git;
    rev = "d14cfd83dae0b1a261667acd416dba17a98d15fa";
    sha256 = "0dbvsw3v26l15h1nmdkr6jhijq87gryyvzbnxqdc823x4m9qfvrw";
  };

  patches = [
    ./nix-build-git.patch
  ];

  spl = spl_git;
})
