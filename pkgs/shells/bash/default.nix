{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "bash-3.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/bash-3.0.tar.gz;
    md5 = "26c4d642e29b3533d8d754995bc277b3";
  };
}
