{ mkDerivation, libutil, ... }:
mkDerivation {
  path = "usr.sbin/nscd";
  buildInputs = [ libutil ];
}
