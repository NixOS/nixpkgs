{
  mkDerivation,
  stdenv,
  lib,
}:
mkDerivation {
  path = "sbin/init";
  extraPaths = [ "sbin/mount" ];
  NO_FSCHG = "yes";
  MK_TESTS = "no";

  meta = {
    broken = !stdenv.hostPlatform.isStatic;
    platforms = lib.platforms.freebsd;
    mainProgram = "init";
  };
}
