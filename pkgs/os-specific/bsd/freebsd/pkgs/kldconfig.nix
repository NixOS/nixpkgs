{ mkDerivation, lib }:
mkDerivation {
  path = "sbin/kldconfig";

  meta.platforms = lib.platforms.freebsd;
}
