{ lib, stdenv, fetchFromGitHub, cmake, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf, Cocoa }:

stdenv.mkDerivation rec {
  pname = "flare-engine";
  version = "1.12rc2";

  src = fetchFromGitHub {
    owner = "flareteam";
    repo = pname;
    rev = "v${version}";
    sha256 = "10il9dpbcka1w5glmhv48bqwww44csmhq426lvsc7z84444gvvgq";
  };

  patches = [ ./desktop.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 SDL2_image SDL2_mixer SDL2_ttf ]
    ++ lib.optional stdenv.isDarwin Cocoa;

  meta = with lib; {
    description = "Free/Libre Action Roleplaying Engine";
    homepage = "https://github.com/flareteam/flare-engine";
    maintainers = [ maintainers.aanderse ];
    license = [ licenses.gpl3 ];
    platforms = platforms.unix;
  };
}
