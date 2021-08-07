{lib, stdenv, fetchurl, SDL, libGLU, libGL, SDL_image, freealut, openal, libvorbis,
pkg-config}:

stdenv.mkDerivation rec {
  pname = "ultimate-stunts";
  version = "0.7.6.1";
  src = fetchurl {
    url = "mirror://sourceforge/ultimatestunts/ultimatestunts-srcdata-${lib.replaceStrings ["."] [""] version}.tar.gz";
    sha256 = "0rd565ml6l927gyq158klhni7myw8mgllhv0xl1fg9m8hlzssgrv";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL libGLU libGL SDL_image freealut openal libvorbis ];

  postPatch = ''
    sed -e '1i#include <unistd.h>' -i $(find . -name '*.c' -o -name '*.cpp')
  '';

  meta = {
    homepage = "http://www.ultimatestunts.nl/";
    description = "Remake of the popular racing DOS-game Stunts";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux;
  };
}
