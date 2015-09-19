{ callPackage, stdenv, fetchFromGitHub, spl_git, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-09-11";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "zfs";
    rev = "7a27ad00ae142b38d4aef8cc0af7a72b4c0e44fe";
    sha256 = "1jqm2a9mldp4km5m454zszsw6p8hrqd7xrbf52pgp82kf5w3d6wz";
  };

  patches = [
    ./nix-build.patch
    ./0.6.5-fix-corruption.patch
  ];

  spl = spl_git;
})
