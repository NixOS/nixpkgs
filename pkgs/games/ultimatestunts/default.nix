{stdenv, fetchurl, SDL, mesa, SDL_image, freealut, openal, libvorbis,
pkgconfig}:

stdenv.mkDerivation rec {
  name = "ultimate-stunts-0.7.6.1";
  src = fetchurl {
    url = mirror://sourceforge/ultimatestunts/ultimatestunts-srcdata-0761.tar.gz;
    sha256 = "0rd565ml6l927gyq158klhni7myw8mgllhv0xl1fg9m8hlzssgrv";
  };

  buildInputs = [ SDL mesa SDL_image freealut openal libvorbis pkgconfig ];

  postPatch = ''
    sed -e '1i#include <unistd.h>' -i $(find . -name '*.c' -o -name '*.cpp')
  '';

  meta = {
    homepage = http://www.ultimatestunts.nl/;
    description = "Remake of the popular racing DOS-game Stunts";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
