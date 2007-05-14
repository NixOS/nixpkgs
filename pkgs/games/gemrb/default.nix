{stdenv, fetchurl, SDL, openal, freealut, zlib, libpng, python}:

stdenv.mkDerivation {
  name = "gemrb-0.2.8";
  
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/gemrb/gemrb-0.2.8.tar.gz;
    sha256 = "1a0pald30m941i67nc7silz36pc1ixrfgkvsr7dcac6mwqmi89kr";
  };

  buildInputs = [SDL openal freealut libpng python];

  configureFlags = "--with-zlib=${zlib}";

  meta = {
    description = "A reimplementation of the Infinity Engine "
      + " (used by Baldur's Gate, Icewind Dale, Planescape: Torment, etc.)";
    homepage = http://gemrb.sourceforge.net/;
  };
}
