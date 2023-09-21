{ lib
, fetchFromGitHub
, stdenv
, cmake
, qtbase
, qtgraphicaleffects
, qtmultimedia
, qtsvg
, qttools
, qtx11extras
, SDL2
, sqlite
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "pegasus-frontend";
  version = "unstable-2023-05-22";

  src = fetchFromGitHub {
    owner = "mmatyas";
    repo = "pegasus-frontend";
    rev = "6421d7a75d29a82ea06008e4a08ec14e074430d9";
    fetchSubmodules = true;
    sha256 = "sha256-mwJm+3zMP4alcis7OFQUcH3eXlRTZhoZYtxKrvCQGc8=";
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
    description = "A cross platform, customizable graphical frontend for launching emulators and managing your game collection.";
    homepage = "https://pegasus-frontend.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tengkuizdihar ];
    platforms = platforms.linux;
  };
}
