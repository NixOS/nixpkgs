{stdenv, fetchurl, zlib, libjpeg, libpng, imake}:

stdenv.mkDerivation rec {
  name = "transfig-3.2.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.tex.ac.uk/pub/archive/graphics/transfig/transfig.3.2.4.tar.gz;
    sha256 = "0429snhp5acbz61pvblwlrwv8nxr6gf12p37f9xxwrkqv4ir7dd4";
  };

  buildInputs = [zlib libjpeg libpng imake];
  inherit libpng;

  hardeningDisable = [ "format" ];

  patches = [prefixPatch1 prefixPatch2 prefixPatch3 varargsPatch gensvgPatch];

  prefixPatch1 =
    ./patch-fig2dev-dev-Imakefile;

  prefixPatch2 =
    ./patch-fig2dev-Imakefile;

  prefixPatch3 =
    ./patch-transfig-Imakefile;

  varargsPatch =
    ./patch-fig2dev-fig2dev.h;

  gensvgPatch =
    ./patch-fig2dev-dev-gensvg.c;

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
