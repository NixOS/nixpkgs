{ lib, stdenv, pkg-config, darwin, fetchurl, SDL2 }:

stdenv.mkDerivation rec {
  pname = "SDL2_net";
  version = "2.0.1";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_net/release/${pname}-${version}.tar.gz";
    sha256 = "08cxc1bicmyk89kiks7izw1rlx5ng5n6xpy8fy0zxni3b9z8mkhm";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optional stdenv.isDarwin darwin.libobjc;

  configureFlags = lib.optional stdenv.isDarwin "--disable-sdltest";

  propagatedBuildInputs = [ SDL2 ];

  meta = with lib; {
    description = "SDL multiplatform networking library";
    homepage = "https://www.libsdl.org/projects/SDL_net";
    license = licenses.zlib;
    maintainers = with maintainers; [ MP2E ];
    platforms = platforms.unix;
  };
}
