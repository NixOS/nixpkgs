{ callPackage, stdenv, fetchgit, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-07-01";

  src = fetchgit {
    url = git://github.com/zfsonlinux/zfs.git;
    rev = "a7b10a931911d3a98a90965795daad031c6d33a2";
    sha256 = "0llqbc37f4szx7mwi6j3xmxxz03g3ib7cwypmpcyi0nwkssav5xi";
  };

  patches = [ ./nix-build.patch ];

  spl = spl_git;
})
