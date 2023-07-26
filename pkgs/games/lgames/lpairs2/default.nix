{ lib
, stdenv
, fetchurl
, SDL2
, SDL2_image
, SDL2_mixer
, SDL2_ttf
, directoryListingUpdater
}:

stdenv.mkDerivation rec {
  pname = "lpairs2";
  version = "2.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/${pname}-${version}.tar.gz";
    hash = "sha256-n2/3QxsnRzVgzKzOUF6RLzpHJ2R8z67Mkjwdh2ghn28=";
  };

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ];

  passthru.updateScript = directoryListingUpdater {
    inherit pname version;
    url = "https://lgames.sourceforge.io/LPairs/";
    extraRegex = "(?!.*-win(32|64)).*";
  };

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "http://lgames.sourceforge.net/LPairs/";
    description = "Matching the pairs - a typical Memory Game";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
