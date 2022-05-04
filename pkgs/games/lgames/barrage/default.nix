{ lib
, stdenv
, fetchurl
, SDL
, SDL_mixer
}:

stdenv.mkDerivation rec {
  pname = "barrage";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/${pname}-${version}.tar.gz";
    hash = "sha256-p4iXq2qM9tU9QJO7irriBN36OiLFyrnnYiDkmH3naQQ=";
  };

  buildInputs = [
    SDL
    SDL_mixer
  ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://lgames.sourceforge.io/Barrage/";
    description = "A destructive action game";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (SDL.meta) platforms;
  };
}
