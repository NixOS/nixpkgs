{ mkDerivation }:
mkDerivation {
  path = "lib/libexpat";
  extraPaths = [ "contrib/expat" ];
  buildInputs = [ ];
  outputs = [
    "out"
    "debug"
  ];
}
