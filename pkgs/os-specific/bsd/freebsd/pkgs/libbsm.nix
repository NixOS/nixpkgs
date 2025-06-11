{ mkDerivation, libpam }:
mkDerivation {
  path = "lib/libbsm";
  extraPaths = [ "contrib/openbsm" ];
  buildInputs = [ libpam ];
  MK_TESTS = "no";
}
