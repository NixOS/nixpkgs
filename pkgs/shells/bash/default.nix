{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "bash-3.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/bash/bash-3.1.tar.gz;
    md5 = "ef5304c4b22aaa5088972c792ed45d72";
  };
}
