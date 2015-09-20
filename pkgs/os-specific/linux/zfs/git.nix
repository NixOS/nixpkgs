{ callPackage, stdenv, fetchFromGitHub, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-09-19";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "zfs";
    rev = "3af56fd95fbe8b417d7ed7c9c25ef59d6f1ee161";
    sha256 = "08sx1jzwrsdyvvlcf5as7rkglgbx5x6zvfn8ps8gk4miqfckq4z0";
  };

  patches = [ ./nix-build.patch ];

  spl = spl_git;
})
