{ mkDerivation }:

mkDerivation {
  path = "usr.bin/getent";
  patches = [ ./getent.patch ];
}
