{ callPackage, stdenv, fetchgit, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-03-05";

  src = fetchgit {
    url = git://github.com/zfsonlinux/zfs.git;
    rev = "417104bdd3c7ce07ec58674dd078f9891c3bc780";
    sha256 = "0w6cr6avi3raxdzqzljn840k1vcvakqrb88jifsqnd5asws5v8wm";
  };

  patches = [
    ./nix-build-git.patch
  ];

  spl = spl_git;
})
