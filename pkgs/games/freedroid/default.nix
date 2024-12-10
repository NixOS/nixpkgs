{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  autoreconfHook,
  SDL,
  SDL_mixer,
  SDL_image,
  SDL_gfx,
  libvorbis,
  libjpeg,
  libpng,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "freedroid";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "ReinhardPrix";
    repo = "FreedroidClassic";
    rev = "release-${version}";
    sha256 = "027wns25nyyc8afyhyp5a8wn13x9nlzmnqzqyyma1055xjy5imis";
  };

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
    autoreconfHook
  ];
  buildInputs = [
    SDL
    SDL_image
    SDL_gfx
    SDL_mixer
    libjpeg
    libpng
    libvorbis
    zlib
  ];

  postPatch = ''
    touch NEWS
  '';

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/32x32/apps
    convert graphics/paraicon.bmp $out/share/icons/hicolor/32x32/apps/freedroid.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = "Freedroid Classic";
      comment = "A clone of the classic game 'Paradroid' on Commodore 64";
      categories = [
        "Game"
        "ArcadeGame"
      ];
    })
  ];

  meta = with lib; {
    description = "A clone of the classic game 'Paradroid' on Commodore 64";
    mainProgram = "freedroid";
    homepage = "https://github.com/ReinhardPrix/FreedroidClassic";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ iblech ];
    platforms = platforms.unix;
    # Builds but fails to render to the screen at runtime.
    broken = stdenv.isDarwin;
  };
}
