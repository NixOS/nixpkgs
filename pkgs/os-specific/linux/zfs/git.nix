{ callPackage, stdenv, fetchFromGitHub, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-08-30";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "zfs";
    rev = "c6a3a222d3a1d2af94205a218c0ba455200fb945";
    sha256 = "0alzkngw36ik4vpw0z8nnk5qysh2z6v231c23rw7jlcqfdd8ji8p";
  };

  patches = [ ./nix-build.patch ];

  spl = spl_git;
})
