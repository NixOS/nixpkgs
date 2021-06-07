{ lib, stdenv, cmake, fetchurl, pkg-config, SDL, SDL_mixer, SDL_net, wxGTK30 }:

stdenv.mkDerivation rec {
  pname = "odamex";
  version = "0.8.2";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-src-${version}.tar.bz2";
    sha256 = "0d4v1l7kghkz1xz92jxlx50x3iy94z7ix1i3209m5j5545qzxrqq";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ SDL SDL_mixer SDL_net wxGTK30 ];

  meta = {
    homepage = "http://odamex.net/";
    description = "A client/server port for playing old-school Doom online";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ MP2E ];
  };
}
