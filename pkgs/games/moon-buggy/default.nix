{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  baseName = "moon-buggy";
  version = "1.0.51";
  name = "${baseName}-${version}";

  buildInputs = [
    ncurses
  ];

  src = fetchurl {
    url = "http://m.seehuhn.de/programs/${name}.tar.gz";
    sha256 = "0gyjwlpx0sd728dwwi7pwks4zfdy9rm1w1xbhwg6zip4r9nc2b9m";
  };

  meta = {
    description = ''A simple character graphics game where you drive some kind of car across the moon's surface'';
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.rybern];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://www.seehuhn.de/pages/moon-buggy;
  };
}
