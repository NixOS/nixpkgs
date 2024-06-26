{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  qtbase,
  qtscript,
}:

stdenv.mkDerivation rec {
  pname = "qbs";

  version = "1.24.1";

  src = fetchFromGitHub {
    owner = "qbs";
    repo = "qbs";
    rev = "v${version}";
    sha256 = "sha256-nL7UZh29Oecu3RvXYg5xsin2IvPWpApleLH37sEdSAI=";
  };

  nativeBuildInputs = [ qmake ];

  dontWrapQtApps = true;

  qmakeFlags = [
    "QBS_INSTALL_PREFIX=$(out)"
    "qbs.pro"
  ];

  buildInputs = [
    qtbase
    qtscript
  ];

  meta = with lib; {
    description = "Tool that helps simplify the build process for developing projects across multiple platforms";
    homepage = "https://wiki.qt.io/Qbs";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ expipiplus1 ];
    platforms = platforms.linux;
  };
}
