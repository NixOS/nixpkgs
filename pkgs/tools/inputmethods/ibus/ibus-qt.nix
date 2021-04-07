{ lib, stdenv, fetchurl, ibus, cmake, pkg-config, qt4, icu, doxygen }:

stdenv.mkDerivation rec {
  pname = "ibus-qt";
  version = "1.3.3";

  src = fetchurl {
    url = "https://github.com/ibus/ibus-qt/releases/download/${version}/${pname}-${version}-Source.tar.gz";
    sha256 = "1q9g7qghpcf07valc2ni7yf994xqx2pmdffknj7scxfidav6p19g";
  };

  nativeBuildInputs = [ cmake pkg-config doxygen ];
  buildInputs = [ ibus qt4 icu ];

  cmakeFlags = [ "-DQT_PLUGINS_DIR=lib/qt4/plugins" ];

  meta = with lib; {
    homepage    = "https://github.com/ibus/ibus-qt/";
    description = "Qt4 interface to the ibus input method";
    platforms   = platforms.linux;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ gebner ];
  };
}
