{ mkDerivation, libutil, libxo, patchesRoot, ... }:
mkDerivation {
  path = "sbin/mount";
  buildInputs = [ libutil libxo ];

  patches = [ /${patchesRoot}/mount-use-path.patch ];

  clangFixup = true;
}
