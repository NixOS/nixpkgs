{ lib, stdenv, fetchurl, SDL, SDL_mixer }:

stdenv.mkDerivation rec {
  pname = "ltris";
  version = "1.2.5";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/${pname}-${version}.tar.gz";
    hash = "sha256-Ksb5TdQMTEzaJfjHVhgq27dSFvZxUnNUQ6OpAU+xwzM=";
  };

  buildInputs = [
    SDL
    SDL_mixer
  ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://lgames.sourceforge.io/LTris/";
    description = "Tetris clone from the LGames series";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ciil ];
    inherit (SDL.meta) platforms;
  };
}
