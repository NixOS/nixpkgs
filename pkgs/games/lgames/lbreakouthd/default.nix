{ lib
, stdenv
, fetchurl
, directoryListingUpdater
, SDL2
, SDL2_image
, SDL2_mixer
, SDL2_ttf
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lbreakouthd";
<<<<<<< HEAD
  version = "1.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/lbreakouthd-${finalAttrs.version}.tar.gz";
    hash = "sha256-BpF583f2if4FeJ2Fi/8GZYuh5T37GXdNq/Ww4LM65wY=";
=======
  version = "1.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/lbreakouthd-${finalAttrs.version}.tar.gz";
    hash = "sha256-fK7w5uS7zPJnbEmY3YpxoA9cGuooQbVlDB9Mu6yB8hw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ];

  hardeningDisable = [ "format" ];

  passthru.updateScript = directoryListingUpdater {
    inherit (finalAttrs) pname version;
    url = "https://lgames.sourceforge.io/LBreakoutHD/";
    extraRegex = "(?!.*-win(32|64)).*";
  };

  meta = {
    homepage = "https://lgames.sourceforge.io/LBreakoutHD/";
    description = "A widescreen Breakout clone";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (SDL2.meta) platforms;
    broken = stdenv.isDarwin;
  };
})
