{ callPackage, stdenv, fetchgit, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-03-25";

  src = fetchgit {
    url = git://github.com/zfsonlinux/zfs.git;
    rev = "7d90f569b3f05def7cbd0a52ce8ac3040364d702";
    sha256 = "09qcfd3h6zjwvgr1prs41qi8wlzvdv8x4sfrcf95bjj6h25v7n51";
  };

  patches = [
    ./nix-build-git.patch
  ];

  spl = spl_git;
})
