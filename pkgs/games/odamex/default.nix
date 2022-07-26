{ lib, stdenv, cmake, fetchurl, pkg-config, SDL, SDL_mixer, SDL_net, wxGTK30 }:

stdenv.mkDerivation rec {
  pname = "odamex";
  version = "0.9.5";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-src-${version}.tar.bz2";
    sha256 = "sha256-WBqO5fWzemw1kYlY192v0nnZkbIEVuWmjWYMy+1ODPQ=";
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
