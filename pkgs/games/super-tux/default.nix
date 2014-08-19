{ fetchurl, stdenv, SDL, SDL_image, SDL_mixer, curl, gettext, libogg, libvorbis, mesa, openal }:

let

    version = "0.1.3";

in

stdenv.mkDerivation {
  name = "supertux-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/supertux.berlios/supertux-${version}.tar.bz2";
    sha256 = "15xdq99jy4hayr96jpqcp15rbr9cs5iamjirafajcrkpa61mi4h0";
  };

  buildInputs = [ SDL SDL_image SDL_mixer curl gettext libogg libvorbis mesa openal ];

  patches = [ ./g++4.patch ];

  meta = {
    description = "Classic 2D jump'n run sidescroller game";

    homepage = http://supertux.lethargik.org/index.html;

    license = stdenv.lib.licenses.gpl2;
  };
}
