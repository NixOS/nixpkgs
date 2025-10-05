{ mkDerivation, lib }:
mkDerivation {
  path = "sbin/dmesg";

  meta.platforms = lib.platforms.freebsd;
}
