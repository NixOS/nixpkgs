{ stdenv, fetchurl, SDL, SDL_mixer, SDL_image, SDL_ttf, SDL_gfx
, pkgconfig, fontconfig, libzip, zip, zlib }:

stdenv.mkDerivation rec {
  name = "freedink-1.08.20100420";

  src = fetchurl {
    url = "mirror://gnu/freedink/${name}.tar.gz";
    sha256 = "0jw0690k7wgsga74nd8m1c3k34xmzgav6z0hhpx507krw2mkbm90";
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
