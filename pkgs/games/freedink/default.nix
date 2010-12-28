{ stdenv, fetchurl, SDL, SDL_mixer, SDL_image, SDL_ttf, SDL_gfx
, pkgconfig, fontconfig, libzip, zip, zlib }:

stdenv.mkDerivation rec {
  name = "freedink-1.08.20101114";

  src = fetchurl {
    url = "mirror://gnu/freedink/${name}.tar.gz";
    sha256 = "0h3i7p7awk5flymh22xaazm2r56hv86z2il2gmbzrr6xh434zffa";
  };

  buildInputs = [ SDL SDL_mixer SDL_image SDL_ttf SDL_gfx pkgconfig fontconfig libzip zip zlib] ;

  meta = {
    description = "GNU FreeDink, a free, portable and enhanced version of the Dink Smallwood game engine. ";

    longDescription =
      '' GNU FreeDink is a new and portable version of the Dink Smallwood
	 game engine, which runs the original game as well as its D-Mods,
	 with close compatibility, under multiple platforms.
       '';

    homepage = http://www.freedink.org/;
    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.bjg ];
    platforms = stdenv.lib.platforms.all;
  };
}
