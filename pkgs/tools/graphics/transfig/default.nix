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
    fetchurl {
      url = "http://www.darwinports.org/darwinports/dports/print/transfig/files/patch-transfig-Imakefile";
      md5 = "1cfe0df7d3448f6ff914a7a2d85e6f50";
    };

  varargsPatch =
    fetchurl {
      url = "http://www.darwinports.org/darwinports/dports/print/transfig/files/patch-fig2dev-fig2dev.h";
      md5 = "da3cd4f9bee619818c890c5692f042c1";
    };

  gensvgPatch =
    fetchurl {
      url = "http://www.darwinports.org/darwinports/dports/print/transfig/files/patch-fig2dev-dev-gensvg.c";
      md5 = "66a97cbfc313be48183beeeb950e2c86";
    };

}
