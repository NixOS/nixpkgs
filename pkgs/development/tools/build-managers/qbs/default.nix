{ lib, stdenv, fetchFromGitHub, qmake, qtbase, qtscript }:

stdenv.mkDerivation rec {
  pname = "qbs";

  version = "1.23.1";

  src = fetchFromGitHub {
    owner = "qbs";
    repo = "qbs";
    rev = "v${version}";
    sha256 = "sha256-ZAMWPvTzramhIuafYw+lV7Tm3fQKm+nbRdAFdjYDMhs=";
  };

  nativeBuildInputs = [ qmake ];

  dontWrapQtApps = true;

  qmakeFlags = [ "QBS_INSTALL_PREFIX=$(out)" "qbs.pro" ];

  buildInputs = [ qtbase qtscript ];

  meta = with lib; {
    description = "A tool that helps simplify the build process for developing projects across multiple platforms";
    homepage = "https://wiki.qt.io/Qbs";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ expipiplus1 ];
    platforms = platforms.linux;
  };
}
