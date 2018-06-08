{ stdenv, fetchFromGitHub, ibus, cmake, pkgconfig, qt4, icu, doxygen }:

stdenv.mkDerivation rec {
  pname = "ibus-qt";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "ibus";
    repo = pname;
    rev = version;
    sha256 = "1q3p4p1harzn920j8anwmq9ag60nwvlavl01vl2icd2nd110717s";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    ibus cmake qt4 icu doxygen
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
