{ callPackage, stdenv, fetchgit, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-03-20";

  src = fetchgit {
    url = git://github.com/zfsonlinux/zfs.git;
    rev = "bc88866657979c5658441e201e19df365c67ddfe";
    sha256 = "1d97xw7cak64f0ywwskjssnryljidf4hpngmqv0mmz4lk4hwirm9";
  };

  patches = [
    ./nix-build-git.patch
  ];

  spl = spl_git;
})
