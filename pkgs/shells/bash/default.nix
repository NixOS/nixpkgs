{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "bash-3.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/bash/bash-3.0.tar.gz;
    md5 = "26c4d642e29b3533d8d754995bc277b3";
  };
}
