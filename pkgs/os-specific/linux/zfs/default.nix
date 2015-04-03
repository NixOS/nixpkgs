{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.6.3-1.3";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "zfs";
    rev = "zfs-${version}";
    sha256 = "08m5ah8a6zp96djz2xj9rb94zq973dwwfpc26jy0adzdq2q20zb4";
  };

  patches = [
    ./mount_zfs_prefix.patch
    ./nix-build.patch # Remove in >=0.6.4
  ];
})
