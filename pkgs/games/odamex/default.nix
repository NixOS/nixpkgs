{ stdenv, cmake, fetchurl, pkgconfig, SDL, SDL_mixer, SDL_net, wxGTK30 }:

stdenv.mkDerivation rec {
  pname = "odamex";
  version = "0.8.2";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-src-${version}.tar.bz2";
    sha256 = "0d4v1l7kghkz1xz92jxlx50x3iy94z7ix1i3209m5j5545qzxrqq";
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
