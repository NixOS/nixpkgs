{ stdenv, cmake, fetchurl, pkgconfig, SDL, SDL_mixer, SDL_net, wxGTK30 }:

stdenv.mkDerivation rec {
  pname = "odamex";
  version = "0.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-src-${version}.tar.bz2";
    sha256 = "1dz0lqdx3vb62mylqddcdq3vxsl2mvv0w2xskvwgpg0p04fcic2c";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ SDL SDL_mixer SDL_net wxGTK30 ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://odamex.net/";
    description = "A client/server port for playing old-school Doom online";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
