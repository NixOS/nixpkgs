{ stdenv, cmake, fetchurl, pkgconfig, SDL, SDL_mixer, SDL_net }:

stdenv.mkDerivation {
  name = "odamex-0.8.1";
  src = fetchurl {
    url = mirror://sourceforge/odamex/odamex-src-0.8.1.tar.bz2;
    sha256 = "1dz0lqdx3vb62mylqddcdq3vxsl2mvv0w2xskvwgpg0p04fcic2c";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake SDL SDL_mixer SDL_net ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://odamex.net/;
    description = "A client/server port for playing old-school Doom online";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
    broken = true;
  };
}
