{ callPackage, stdenv, fetchgit, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-02-24";

  src = fetchgit {
    url = git://github.com/zfsonlinux/zfs.git;
    rev = "8bdcfb53966313e9ff747e3028390c207cfdbe9a";
    sha256 = "0xcikjb57fz173sjh2wvv96ybvrsx9d24krq09wy9a4psxp7vr8f";
  };

  patches = [
    ./nix-build-git.patch
  ];

  spl = spl_git;
})
