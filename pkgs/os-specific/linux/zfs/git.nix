{ callPackage, fetchgit, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "33b4de5";

  src = fetchgit {
    url = git://github.com/zfsonlinux/zfs.git;
    rev = "5f15fa22167ff665d0db0159551eb90759683984";
    sha256 = "14l1s1rfykj5dz1ssh5c8d1k98qn19l48sd31lwshiczx63zjygw";
  };

  patches = [
    ./nix-build-git.patch
  ];

  spl = spl_git;
})
