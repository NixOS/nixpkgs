{ mkDerivation, lib, stdenv, libsbuf, libbsdxml, ...}:
mkDerivation {
  path = "lib/lib80211";
  buildInputs = [ libsbuf libbsdxml ];
  clangFixup = true;
}
