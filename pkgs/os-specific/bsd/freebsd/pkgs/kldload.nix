{ mkDerivation, lib }:
mkDerivation {
  path = "sbin/kldload";

  meta.platforms = lib.platforms.freebsd;
}
