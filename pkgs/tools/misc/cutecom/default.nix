{ stdenv, fetchurl, qt4, cmake }:

stdenv.mkDerivation rec {
  name = "cutecom-0.22.0";
  src = fetchurl {
    url = "http://cutecom.sourceforge.net/${name}.tar.gz";
    sha256 = "199fvl463nyn77r3nm8xgzgifs28j5759kkcnc5xbwww2nk20rhv";
  };
  buildInputs = [qt4 cmake];

  meta = {
    description = "A graphical serial terminal";
    version = "0.22.0";
    homepage = http://cutecom.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.bennofs ];
    platforms = stdenv.lib.platforms.unix;
  };
}
