{
  lib,
  mkDerivation,
  libxo,
}:
mkDerivation {
  path = "usr.sbin/arp";
  buildInputs = [ libxo ];

  meta.mainProgram = "arp";
}
