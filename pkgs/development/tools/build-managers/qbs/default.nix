{ lib, stdenv, fetchFromGitHub, qmake, qtbase, qtscript }:

stdenv.mkDerivation rec {
  pname = "qbs";

  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "qbs";
    repo = "qbs";
    rev = "v${version}";
    sha256 = "sha256-D2Nqou4wUIsePKr+ReAyFO/22vQlwcs4Li+3+6btR6Y=";
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
