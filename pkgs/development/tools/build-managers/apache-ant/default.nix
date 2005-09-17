{stdenv, fetchurl, jdk, name}:

let {
  body =
    stdenv.mkDerivation {
      name = name;
      builder = ./builder.sh;
      buildInputs = [ant jdk];
      inherit ant jdk;
    };

  ant =
    (import ./core-apache-ant.nix) {
      inherit fetchurl stdenv;
    };
}
