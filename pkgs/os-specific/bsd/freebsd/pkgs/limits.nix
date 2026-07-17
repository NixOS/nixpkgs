{ mkDerivation, libutil }:
mkDerivation {
  path = "usr.bin/limits";
  buildInputs = [ libutil ];
  MK_TESTS = "no";
}
