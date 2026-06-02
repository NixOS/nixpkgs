{ mkDerivation }:
mkDerivation {
  path = "usr.bin/mkimg";
  extraPaths = [ "sys/sys/disk" ];
  MK_TESTS = "no";
}
