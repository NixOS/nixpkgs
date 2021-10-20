{ lib, stdenv, fetchFromGitHub, qmake, qtbase, qtscript }:

stdenv.mkDerivation rec {
  pname = "qbs";

  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "qbs";
    repo = "qbs";
    rev = "v${version}";
    sha256 = "sha256-gKabKjd8GT5eFmobUFK6IUQ+b8Jjn/Kr68i1fXgJS4Q=";
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
