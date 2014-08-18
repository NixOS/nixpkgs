{stdenv, fetchurl, SDL, mesa, zlib, libpng, libvorbis, libmikmod, SDL_sound } :

stdenv.mkDerivation rec {
  name = "gltron-0.70";
  src = fetchurl {
    url = "mirror://sourceforge/gltron/${name}-source.tar.gz";
    sha256 = "e0c8ebb41a18a1f8d7302a9c2cb466f5b1dd63e9a9966c769075e6b6bdad8bb0";
  };

  patches = [ ./gentoo-prototypes.patch ];

  # The build fails, unless we disable the default -Wall -Werror
  configureFlags = "--disable-warn";

  buildInputs = [ SDL mesa zlib libpng libvorbis libmikmod SDL_sound ];

  meta = {
    homepage = http://www.gltron.org/;
    description = "Game based on the movie Tron";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
