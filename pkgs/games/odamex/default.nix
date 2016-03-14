{ stdenv, cmake, fetchurl, pkgconfig, SDL, SDL_mixer, SDL_net }:

stdenv.mkDerivation rec {
  name = "odamex-0.7.0";
  src = fetchurl {
    url = mirror://sourceforge/odamex/odamex-src-0.7.0.tar.bz2;
    sha256 = "0cb6p58yv55kdyfj7s9n9xcwpvxrj8nyc6brw9jvwlc5n4y3cd5a";
  };

  cmakeFlags = ''
    -DCMAKE_BUILD_TYPE=Release
  '';

  buildInputs = [ cmake pkgconfig SDL SDL_mixer SDL_net ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://odamex.net/;
    description = "A client/server port for playing old-school Doom online";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
