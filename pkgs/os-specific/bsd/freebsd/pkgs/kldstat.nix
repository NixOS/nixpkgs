{ mkDerivation, lib }:
mkDerivation {
  path = "sbin/kldstat";

  meta.platforms = lib.platforms.freebsd;
}
