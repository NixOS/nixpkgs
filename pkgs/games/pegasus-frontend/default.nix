{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  qtbase,
  qtgraphicaleffects,
  qtmultimedia,
  qtsvg,
  qttools,
  qtx11extras,
  SDL2,
  sqlite,
  wrapQtAppsHook,
}:

stdenv.mkDerivation {
  pname = "pegasus-frontend";
  version = "0-unstable-2024-11-11";

  src = fetchFromGitHub {
    owner = "mmatyas";
    repo = "pegasus-frontend";
    rev = "54362976fd4c6260e755178d97e9db51f7a896af";
    fetchSubmodules = true;
    hash = "sha256-DqtkvDg0oQL9hGB+6rNXe3sDBywvnqy9N31xfyl6nbI=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    qtsvg
    qtgraphicaleffects
    qtx11extras
    sqlite
    SDL2
  ];

  meta = with lib; {
    description = "Cross platform, customizable graphical frontend for launching emulators and managing your game collection";
    mainProgram = "pegasus-fe";
    homepage = "https://pegasus-frontend.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tengkuizdihar ];
    platforms = platforms.linux;
  };
}
