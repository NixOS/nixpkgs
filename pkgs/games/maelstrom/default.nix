{ lib, stdenv, fetchurl, makeDesktopItem, SDL2, SDL2_net }:

stdenv.mkDerivation rec {
  pname = "maelstrom";
  version = "3.0.7";

  src = fetchurl {
    url = "http://www.libsdl.org/projects/Maelstrom/src/Maelstrom-${version}.tar.gz";
    sha256 = "0dm0m5wd7amrsa8wnrblkv34sq4v4lglc2wfx8klfkdhyhi06s4k";
  };

  # this fixes a typedef compilation error with gcc-3.x
  patches = [ ./fix-compilation.patch ];

  buildInputs = [ SDL2 SDL2_net ];

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/games/Maelstrom/Maelstrom $out/bin/maelstrom
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "maelstrom";
      exec = "maelstrom";
      desktopName = "Maelstrom";
      genericName = "Maelstrom";
      comment = "An arcade-style game resembling Asteroids";
      categories = [ "Game" ];
    })
  ];

  meta = with lib; {
    description = "Arcade-style game resembling Asteroids";
    mainProgram = "maelstrom";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ tmountain ];
  };
}
