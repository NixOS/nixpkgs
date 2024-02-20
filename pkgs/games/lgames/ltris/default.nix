{ lib
, stdenv
, fetchurl
, SDL
, SDL_mixer
, directoryListingUpdater
}:

stdenv.mkDerivation rec {
  pname = "ltris";
  version = "1.2.8";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/${pname}-${version}.tar.gz";
    hash = "sha256-2e5haaU2pqkBk82qiF/3HQgSBVPHP09UwW+TQqpGUqA=";
  };

  buildInputs = [
    SDL
    SDL_mixer
  ];

  hardeningDisable = [ "format" ];

  passthru.updateScript = directoryListingUpdater {
    inherit pname version;
    url = "https://lgames.sourceforge.io/LTris/";
    extraRegex = "(?!.*-win(32|64)).*";
  };

  meta = with lib; {
    homepage = "https://lgames.sourceforge.io/LTris/";
    description = "Tetris clone from the LGames series";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ciil ];
    inherit (SDL.meta) platforms;
    broken = stdenv.isDarwin;
  };
}
