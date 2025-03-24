{ mkDerivation, lib }:
mkDerivation {
  path = "sbin/kldunload";

  meta.platforms = lib.platforms.freebsd;
}
