{ callPackage, stdenv, fetchgit, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-02-13";

  src = fetchgit {
    url = git://github.com/zfsonlinux/zfs.git;
    rev = "7d2868d5fc88a4c30769b44f56a3a88a4277a9ab";
    sha256 = "1gf0x8d0zs2h3w910agxm4nb9qr4chs54iiblnqz4k74yyhbmwgg";
  };

  patches = [
    ./nix-build-git.patch
  ];

  spl = spl_git;
})
