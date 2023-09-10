{ lib
, stdenv
, fetchFromGitHub
, cmake
, inih
, ninja
, pkg-config
, qtbase
, wrapQtAppsHook
, makeDesktopItem
, copyDesktopItems
}:

stdenv.mkDerivation rec {
  pname = "qzdl";
  version = "unstable-2023-04-04";

  src = fetchFromGitHub {
    owner = "qbasicer";
    repo = "qzdl";
    rev = "44aaec0182e781a3cef373e5c795c9dbd9cd61bb";
    hash = "sha256-K/mJQb7uO2H94krWJIJtFRYd6BAe2TX1xBt6fGBb1tA=";
  };

  patches = [
    ./non-bundled-inih.patch
  ];

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    ninja
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    inih
    qtbase
  ];

  postInstall = ''
    install -Dm644 $src/res/zdl3.svg $out/share/icons/hicolor/scalable/apps/zdl3.svg
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "zdl3";
      exec = "zdl %U";
      icon = "zdl3";
      desktopName = "ZDL";
      genericName = "A ZDoom WAD Launcher";
      categories = [ "Game" ];
    })
  ];

  meta = with lib; {
    description = "A ZDoom WAD Launcher";
    homepage = "https://zdl.vectec.net";
    license = licenses.gpl3Only;
    inherit (qtbase.meta) platforms;
    maintainers = with maintainers; [ azahi ];
    mainProgram = "zdl";
  };
}
