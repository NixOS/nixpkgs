<<<<<<< HEAD
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
=======
{ lib, stdenv, fetchurl, pkg-config, glib, python2, gtk2, readline }:

stdenv.mkDerivation rec {
  pname = "gnubg";
  version = "1.06.002";

  src = fetchurl {
    url = "http://gnubg.org/media/sources/gnubg-release-${version}-sources.tar.gz";
    sha256 = "11xwhcli1h12k6rnhhyq4jphzrhfik7i8ah3k32pqw803460n6yf";
  };

  nativeBuildInputs = [ pkg-config python2 glib ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ gtk2 readline ];

  strictDeps = true;

  configureFlags = [ "--with-gtk" "--with--board3d" ];

<<<<<<< HEAD
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
=======
  meta = with lib;
    { description = "World class backgammon application";
      homepage = "http://www.gnubg.org/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      license = licenses.gpl3;
      maintainers = [ maintainers.ehmry ];
      platforms = platforms.linux;
    };
}
