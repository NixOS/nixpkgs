{ callPackage, stdenv, fetchgit, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-04-03";

  src = fetchgit {
    url = git://github.com/zfsonlinux/zfs.git;
    rev = "40d06e3c78c23b199dfd9284809e710fab549391";
    sha256 = "1yxpx7lylbbr6jlm8g2x6xsmh6wmzb8prfg7shks7sib750a4slx";
  };

  patches = [
    ./nix-build-git.patch
  ];

  spl = spl_git;
})
