{stdenv, fetchurl, SDL, libGLU_combined, zlib, libpng, libvorbis, libmikmod, SDL_sound } :

stdenv.mkDerivation rec {
  name = "gltron-0.70";
  src = fetchurl {
    url = "mirror://sourceforge/gltron/${name}-source.tar.gz";
    sha256 = "e0c8ebb41a18a1f8d7302a9c2cb466f5b1dd63e9a9966c769075e6b6bdad8bb0";
  };

  patches = [ ./gentoo-prototypes.patch ];

  postPatch = ''
     # Fix http://sourceforge.net/p/gltron/bugs/15
     sed -i /__USE_MISC/d lua/src/lib/liolib.c
  '';

  # The build fails, unless we disable the default -Wall -Werror
  configureFlags = "--disable-warn";

  buildInputs = [ SDL libGLU_combined zlib libpng libvorbis libmikmod SDL_sound ];

  meta = {
    homepage = http://www.gltron.org/;
    description = "Game based on the movie Tron";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
