{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.6.4.1";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "zfs";
    rev = "zfs-${version}";
    sha256 = "15fh1b2rvzvx4j3vgkwrgy2sd553bzwcvk1zai6phjhb6i2rw8v4";
  };

  patches = [
    ./nix-build.patch
    ./kernel-4.1-compat.patch
  ];
})
