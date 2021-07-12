{ lib, stdenv, fetchFromGitHub, cmake, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf, Cocoa }:

stdenv.mkDerivation rec {
  pname = "flare-engine";
  version = "1.12rc1";

  src = fetchFromGitHub {
    owner = "flareteam";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bl5vayf87y2jd6b1w4nn7pbrhix6dj86xv5kzqxz6b2y65lq73p";
  };

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
