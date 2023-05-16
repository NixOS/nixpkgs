{ lib
, stdenv
, fetchurl
, SDL
, SDL_mixer
}:

stdenv.mkDerivation rec {
  pname = "barrage";
<<<<<<< HEAD
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/${pname}-${version}.tar.gz";
    hash = "sha256-cGYrG7A4Ffh51KyR+UpeWu7A40eqxI8g4LefBIs18kg=";
=======
  version = "1.0.6";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/${pname}-${version}.tar.gz";
    hash = "sha256-nFkkzT5AjcPfXsdxwvEsk4+RX9Py1mVqADvuoxE4Ha4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    broken = stdenv.isDarwin;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
