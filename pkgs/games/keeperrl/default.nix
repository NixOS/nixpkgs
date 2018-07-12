{ stdenv, fetchFromGitHub, SDL2, SDL2_image, openal, libvorbis, zlib, curl,
  libGL, makeWrapper, boost, makeDesktopItem }:

stdenv.mkDerivation rec {
  pname = "keeperrl";
  version = "2019-10-21";

  src = fetchFromGitHub {
    owner = "miki151";
    repo = "keeperrl";
    rev = "74b89ea";
    sha256 = "17rplprichf0l52lbiampp78g8rz3msclkyja3v8kb79nxy93fns";
  };

  patches = [ ./makefile_cflags.patch ];

  buildInputs = [
    SDL2 SDL2_image openal libvorbis zlib curl libGL makeWrapper
  ] ++ stdenv.lib.optional stdenv.isDarwin boost ;

  # Needed so the builder finds SDL.h
  CFLAGS = "-I${SDL2.dev}/include/SDL2";

  makeFlags = [
    "OPT=true"
    "RELEASE=true"
    "STEAMWORKS="
    "DATA_DIR=$(out)/share/keeperrl"
    # use ~/.local/share/KeeperRL if --user-dir not set
    "ENABLE_LOCAL_USER_DIR=true"
  ];

  desktopItem = makeDesktopItem {
    name = "keeperrl";
    desktopName = "KeeperRL";
    comment = "Ambitious dungeon builder with roguelike elements";
    type = "Application";
    categories = "Game";
    exec = "keeper";
  };

  installPhase = ''
    mkdir -p $out/share/keeperrl $out/bin $out/share/applications
    cp ./keeper $out/bin/
    cp -r ./appconfig.txt data_contrib data_free $out/share/keeperrl
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications
  '';

  meta = with stdenv.lib; {
    homepage = http://keeperrl.com/;
    description = "Ambitious dungeon builder with roguelike elements";
    maintainers = with maintainers; [ rardiol ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}

