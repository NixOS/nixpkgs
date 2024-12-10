{
  lib,
  stdenv,
  fetchurl,
  libX11,
  SDL,
  libGLU,
  libGL,
  expat,
  zlib,
  SDL_ttf,
  SDL_image,
}:

stdenv.mkDerivation rec {
  version = "1.5.0";
  pname = "bloodspilot-client";

  src = fetchurl {
    url = "mirror://sourceforge/project/bloodspilot/client-sdl/v${version}/bloodspilot-client-sdl-${version}.tar.gz";
    sha256 = "1qwl95av5an2zl01m7saj6fyy49xpixga7gbn4lwbpgpqs1rbwxj";
  };

  buildInputs = [
    libX11
    SDL
    SDL_ttf
    SDL_image
    libGLU
    libGL
    expat
    zlib
  ];

  NIX_LDFLAGS = "-lX11";

  meta = {
    description = "A multiplayer space combat game (client part)";
    mainProgram = "bloodspilot-client-sdl";
    homepage = "http://bloodspilot.sf.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
  };
}
