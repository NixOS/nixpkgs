{ mkDerivation }:
mkDerivation {
  path = "sbin/newfs_msdos";

  MK_TESTS = "no";
}
