{ mkDerivation, stdenv, lib, libutil,  ... }:
mkDerivation {
  path = "usr.sbin/nscd";
  buildInputs = [libutil];

  clangFixup = true;
}
