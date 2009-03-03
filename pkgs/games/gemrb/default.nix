{stdenv, fetchurl, SDL, openal, freealut, zlib, libpng, python}:

stdenv.mkDerivation {
  name = "gemrb-0.2.9";
  
  src = fetchurl {
    url = mirror://sourceforge/gemrb/gemrb-0.2.9.tar.gz;
    sha256 = "0mygig4icx87a5skdv33yiwn8q4mv55f5qsks4sn40hrs69gcih0";
  };

  buildInputs = [SDL openal freealut libpng python];

  configureFlags = "--with-zlib=${zlib}";

  meta = {
    description = "A reimplementation of the Infinity Engine, used by games such as Baldur's Gate";
    homepage = http://gemrb.sourceforge.net/;
  };
}
