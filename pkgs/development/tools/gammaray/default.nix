{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, wrapQtAppsHook
, qtbase
, wayland
, elfutils
, libbfd
}:

stdenv.mkDerivation rec {
  pname = "gammaray";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-C8bej0q4p8F27hiJUye9G+sZbkAYaV8hW1GKWZyHAis=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    wayland
    elfutils
    libbfd
  ];

  meta = with lib; {
    description = "A software introspection tool for Qt applications developed by KDAB";
    homepage = "https://github.com/KDAB/GammaRay";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
    mainProgram = "gammaray";
  };
}

