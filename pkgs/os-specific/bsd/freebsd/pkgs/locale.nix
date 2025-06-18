{ mkDerivation, libsbuf }:
mkDerivation {
  path = "usr.bin/locale";
  buildInputs = [ libsbuf ];
  extraPaths = [ "lib/libc/locale" ];
  MK_TESTS = "no";
}
