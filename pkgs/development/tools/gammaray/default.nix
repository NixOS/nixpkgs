{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, wrapQtAppsHook
, wayland
, elfutils
, libbfd
}:

stdenv.mkDerivation rec {
  pname = "gammaray";
  version = "2.11.3";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZFLHBPIjkbHlsatwuXdut1C5MpdkVUb9T7TTNhtP764=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
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
  };
}

