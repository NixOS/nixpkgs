{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "zfs";
    rev = "zfs-${version}";
    sha256 = "1jqm2a9mldp4km5m454zszsw6p8hrqd7xrbf52pgp82kf5w3d6wz";
  };

  patches = [
    ./nix-build.patch
    ./0.6.5-fix-corruption.patch
  ];
})
