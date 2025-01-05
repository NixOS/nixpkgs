{ mkDerivation, stdenv }:
mkDerivation {
  path = "sbin/init";
  extraPaths = [ "sbin/mount" ];
  MK_TESTS = "no";

  meta.broken = !stdenv.hostPlatform.isStatic;
}
