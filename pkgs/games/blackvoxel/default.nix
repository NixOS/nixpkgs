{ lib
, stdenv
, fetchFromGitHub
, makeDesktopItem
, imagemagick # for icon for desktop item
, glew110
, SDL
}:

stdenv.mkDerivation rec {
  pname = "blackvoxel";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "Blackvoxel";
    repo = "Blackvoxel";
    rev = version;
    hash = "sha256-Uj3TfxAsLddsPiWDcLKjpduqvgVjnESZM4YPHT90YYY=";
  };

  buildFlags = [ "BV_DATA_LOCATION_DIR=$(out)/data" ];

  nativeBuildInputs = [ imagemagick ];

  buildInputs = [ glew110 SDL ];

  installFlags = [ "doinstall=true BV_DATA_INSTALL_DIR=$(out)/data BV_BINARY_INSTALL_DIR=$(out)/bin" ];

  # data/gui/gametype_back.bmp isn't exactly the official icon but since
  # there is no official icon I chose that one
  postInstall = ''
    convert gui/gametype_back.bmp blackvoxel.png
    install -Dm644 blackvoxel.png $out/share/icons/hicolor/1024x1024/apps/blackvoxel.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Blackvoxel";
      exec = pname;
      icon = pname;
      categories = [ "Game" ];
    })
  ];

  meta = with lib; {
    description = "A Sci-Fi game with industry and automation";
    homepage = "https://www.blackvoxel.com";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ TheBrainScrambler ];
    platforms = platforms.linux;
  };
}
