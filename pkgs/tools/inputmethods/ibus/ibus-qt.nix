{ stdenv, fetchurl, ibus, cmake, pkgconfig, qt4, icu, doxygen }:

stdenv.mkDerivation rec {
  name = "ibus-qt-${version}";
  version = "1.3.3";

  src = fetchurl {
    url = "https://github.com/ibus/ibus-qt/releases/download/${version}/${name}-Source.tar.gz";
    sha256 = "1q9g7qghpcf07valc2ni7yf994xqx2pmdffknj7scxfidav6p19g";
  };

  buildInputs = [
    ibus cmake pkgconfig qt4 icu doxygen
  ];

  cmakeFlags = [ "-DQT_PLUGINS_DIR=lib/qt4/plugins" ];

  meta = with stdenv.lib; {
    homepage    = https://github.com/ibus/ibus-qt/;
    description = "Qt4 interface to the ibus input method";
    platforms   = platforms.linux;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ gebner ];
  };
}
