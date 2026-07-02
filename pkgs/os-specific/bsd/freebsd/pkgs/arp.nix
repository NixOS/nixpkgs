{
  lib,
  mkDerivation,
  libxo,
}:
mkDerivation {
  path = "usr.sbin/arp";
  buildInputs = [ libxo ];

  meta.platforms = lib.platforms.freebsd;
  meta.mainProgram = "arp";
}
