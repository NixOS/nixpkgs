{ lib, stdenv, fetchurl, pkg-config, glib, python3, gtk2, readline,
  copyDesktopItems, makeDesktopItem }:

stdenv.mkDerivation rec {
  pname = "gnubg";
  version = "1.07.001";

  src = fetchurl {
    url = "mirror://gnu/gnubg/gnubg-release-${version}-sources.tar.gz";
    hash = "sha256-cjmXKUGcrZ8RLDBmoS0AANpFCkVq3XsJTYkVUGnWgh4=";
  };

  nativeBuildInputs = [ copyDesktopItems pkg-config python3 glib ];

  buildInputs = [ gtk2 readline ];

  strictDeps = true;

  configureFlags = [ "--with-gtk" "--with--board3d" ];

  desktopItems = makeDesktopItem {
    desktopName = "GNU Backgammon";
    name = pname;
    genericName = "Backgammon";
    comment = meta.description;
    exec = pname;
    icon = pname;
    categories = [ "Game" "GTK" "StrategyGame" ];
  };

  meta = with lib;
    { description = "World class backgammon application";
      homepage = "https://www.gnu.org/software/gnubg/";
      license = licenses.gpl3;
      maintainers = [ maintainers.ehmry ];
      platforms = platforms.linux;
    };
}
