{ lib
, stdenv
, fetchurl
, SDL2
, SDL2_image
, SDL2_mixer
, SDL2_ttf
}:

stdenv.mkDerivation rec {
  pname = "lpairs2";
  version = "2.1";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/${pname}-${version}.tar.gz";
    hash = "sha256-35KYDnPWOjNPu9wz9AWvSBAo1tdVDo7I2TNxtxE5RRg=";
  };

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "http://lgames.sourceforge.net/LPairs/";
    description = "Matching the pairs - a typical Memory Game";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
