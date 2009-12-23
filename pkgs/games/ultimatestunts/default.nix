{stdenv, fetchurl, SDL, mesa, SDL_image, freealut}:

stdenv.mkDerivation rec {
  name = "ultimate-stunts-0.7.5.1";
  src = fetchurl {
    url = mirror://sourceforge/ultimatestunts/ultimatestunts-srcdata-0751.tar.gz;
    sha256 = "1s4xkaw0i6vqkjhi63plmrbrhhr408i3pv36qkpchpiiiw5bb7lv";
  };

  buildInputs = [ SDL mesa SDL_image freealut ];

  meta = {
    homepage = http://www.ultimatestunts.nl/;
    description = "Remake of the popular racing DOS-game Stunts";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
