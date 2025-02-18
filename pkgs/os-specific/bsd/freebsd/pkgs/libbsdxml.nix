{ mkDerivation }:
mkDerivation {
  path = "lib/libexpat";
  extraPaths = [ "contrib/expat" ];
  buildInputs = [ ];
}
