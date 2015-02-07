{ callPackage, fetchgit, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "33b4de5";

  src = fetchgit {
    url = git://github.com/zfsonlinux/zfs.git;
    rev = "33b4de513ee81c2a87e1b954a9544a5eec1f8f94";
    sha256 = "07kdml65l22z1xi8jif5hr7zr7a8mykyms4f5yrf8nyad20kp6il";
  };

  patches = [
    ./nix-build-git.patch
    ./3.19-compat-git.patch # Remove once PR-3084 is mainlined
  ];

  spl = spl_git;
})
