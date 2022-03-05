{lib, stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  pname = "moon-buggy";
  version = "1.0.51";

  buildInputs = [
    ncurses
  ];

  src = fetchurl {
    url = "http://m.seehuhn.de/programs/moon-buggy-${version}.tar.gz";
    sha256 = "0gyjwlpx0sd728dwwi7pwks4zfdy9rm1w1xbhwg6zip4r9nc2b9m";
  };

  meta = {
    description = "A simple character graphics game where you drive some kind of car across the moon's surface";
    license = lib.licenses.gpl2;
    maintainers = [lib.maintainers.rybern];
    platforms = lib.platforms.linux;
    homepage = "https://www.seehuhn.de/pages/moon-buggy";
  };
}
