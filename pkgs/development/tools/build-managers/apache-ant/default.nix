{stdenv, fetchurl, j2sdk}:

rec {
  body =
    stdenv.mkDerivation {
      name = ant.realname;
      builder = ./builder.sh;
      buildInputs = [ant j2sdk];
      inherit ant j2sdk;
    };

  ant =
    (import ./core-apache-ant.nix) {
      inherit fetchurl stdenv;
    };
}
