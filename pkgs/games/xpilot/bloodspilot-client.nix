{stdenv, fetchurl, libX11, SDL, mesa, expat, SDL_ttf, SDL_image}:
let
  buildInputs = [
    libX11 SDL SDL_ttf SDL_image mesa expat
  ];
in
stdenv.mkDerivation rec {
  version = "1.5.0";
  name = "bloodspilot-client-${version}";
  inherit buildInputs;
  src = fetchurl {
    url = "mirror://sourceforge/project/bloodspilot/client-sdl/v${version}/bloodspilot-client-sdl-${version}.tar.gz";
    sha256 = "1qwl95av5an2zl01m7saj6fyy49xpixga7gbn4lwbpgpqs1rbwxj";
  };
  NIX_LDFLAGS=["-lX11"];
  meta = {
    inherit version;
    description = ''A multiplayer space combat game (client part)'';
    homepage = "http://bloodspilot.sf.net/";
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
