{stdenv, fetchurl, j2sdk, name}:

rec {
  body =
    stdenv.mkDerivation {
      name = name;
      builder = ./builder.sh;
      buildInputs = [ant j2sdk];
      inherit ant j2sdk;
    };

  ant =
    (import ./core-apache-ant.nix) {
      inherit fetchurl stdenv;
    };
}
