{stdenv, fetchurl, ncurses}:
stdenv.mkDerivation rec {
  baseName = "moon-buggy";
  version = "1.0.51";
  name = "${baseName}-${version}";

  buildInputs = [
    ncurses
  ];

  src = fetchurl {
    url = "http://m.seehuhn.de/programs/moon-buggy-1.0.51.tar.gz";
    sha256 = "352dc16ccae4c66f1e87ab071e6a4ebeb94ff4e4f744ce1b12a769d02fe5d23f";
  };

  meta = {
    description = ''A simple character graphics game where you drive some kind of car across the moon's surface'';
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.rybern];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://www.seehuhn.de/pages/moon-buggy;
  };
}
