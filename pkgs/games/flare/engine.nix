{ lib, stdenv, fetchFromGitHub, cmake, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf, Cocoa }:

stdenv.mkDerivation rec {
  pname = "flare-engine";
  version = "1.12";

  src = fetchFromGitHub {
    owner = "flareteam";
    repo = pname;
    rev = "v${version}";
    sha256 = "0swav6fzz970wj4iic3b7y06haa05720s2wivc8w7wcw9nzcac7j";
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
