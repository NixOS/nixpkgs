{ callPackage, stdenv, fetchgit, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-04-08";

  src = fetchgit {
    url = git://github.com/zfsonlinux/zfs.git;
    rev = "d07a16360c1ee219b8820f80d035e56a18c58b84";
    sha256 = "0yyc0n960bzd4fmrg1mwp0xy1db7yn90g33ds44chh4g74mrfgdz";
  };

  patches = [ ./nix-build.patch ];

  spl = spl_git;
})
