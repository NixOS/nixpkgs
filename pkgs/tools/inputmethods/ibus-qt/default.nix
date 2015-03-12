{ stdenv, fetchurl, ibus, cmake, pkgconfig, qt4, icu, doxygen }:

stdenv.mkDerivation rec {
  name = "ibus-qt-${version}";
  version = "1.3.2";

  src = fetchurl {
    url = "http://ibus.googlecode.com/files/${name}-Source.tar.gz";
    sha256 = "070c8ef4e6c74eddf7ddf4385936aed730c2dfe2160162e5c56b5158d1061a76";
  };

  buildInputs = [
    ibus cmake pkgconfig qt4 icu doxygen
  ];

  cmakeFlags = [ "-DQT_PLUGINS_DIR=lib/qt4/plugins" ];

  meta = with stdenv.lib; {
    homepage    = https://code.google.com/p/ibus/;
    description = "Qt4 interface to the ibus input method";
    platforms   = platforms.linux;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ gebner ];
  };
}
