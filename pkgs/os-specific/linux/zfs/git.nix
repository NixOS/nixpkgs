{ callPackage, stdenv, fetchgit, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-03-12";

  src = fetchgit {
    url = git://github.com/zfsonlinux/zfs.git;
    rev = "4c7b7eedcde7fababf457ca04445e6d9d1617e29";
    sha256 = "1v0rb4rfs48c66wihfmigc6cmqk6j5r5xlkv5d03shb9h5ypff84";
  };

  patches = [
    ./nix-build-git.patch
  ];

  spl = spl_git;
})
