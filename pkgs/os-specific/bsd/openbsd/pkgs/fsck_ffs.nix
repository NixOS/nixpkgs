{ mkDerivation }:
mkDerivation {
  path = "sbin/fsck_ffs";
  extraPaths = [
    "sbin/fsck"
    "sys/ufs/ffs"
  ];
}
