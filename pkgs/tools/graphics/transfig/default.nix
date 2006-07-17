{stdenv, fetchurl, zlib, libjpeg, libpng, imake}:

stdenv.mkDerivation rec {
  name = "transfig-3.2.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.tex.ac.uk/pub/archive/graphics/transfig/transfig.3.2.4.tar.gz;
    md5 = "742de0f7a3cae74d247bbd0c70dd9dd7";
  };

  buildInputs = [zlib libjpeg libpng imake];
  inherit libpng;

  patches = [prefixPatch1 prefixPatch2 prefixPatch3 varargsPatch gensvgPatch];

  prefixPatch1 =
    ./patch-fig2dev-dev-Imakefile;

  prefixPatch2 =
    ./patch-fig2dev-Imakefile;

  prefixPatch3 =
    ./patch-transfig-Imakefile

  varargsPatch =
    ./patch-fig2dev-fig2dev.h;

  gensvgPatch =
    ./patch-fig2dev-dev-gensvg.c;
}
