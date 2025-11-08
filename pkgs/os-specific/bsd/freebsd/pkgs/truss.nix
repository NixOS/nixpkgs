{ mkDerivation, libsysdecode }:
mkDerivation {
  path = "usr.bin/truss";
  buildInputs = [ libsysdecode ];
}
