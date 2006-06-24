{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "bash-3.1";
  builder = ./builder.sh;
  src = fetchurl {
    #url = http://nix.cs.uu.nl/dist/tarballs/bash-3.0.tar.gz;
    #md5 = "26c4d642e29b3533d8d754995bc277b3";
    url = ftp://ftp.nluug.nl/pub/gnu/bash/bash-3.1.tar.gz;
    md5 = "ef5304c4b22aaa5088972c792ed45d72";
  };
  configureFlags = "--enable-static-link --without-bash-malloc";
}
