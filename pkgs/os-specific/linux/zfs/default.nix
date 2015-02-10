{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.6.3-1.2";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "zfs";
    rev = "zfs-${version}";
    sha256 = "1iqkh08ikmsg8zi7s2pr46z9z7lshbb65pv2ihg1llwmgcm42r9r";
  };

  patches = [
    ./mount_zfs_prefix.patch
    ./nix-build.patch # Remove in >=0.6.4
  ];
})
