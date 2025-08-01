{ mkDerivation, libgeom }:
mkDerivation {
  path = "sbin/mdconfig";
  buildInputs = [ libgeom ];

  MK_TESTS = "no";
}
