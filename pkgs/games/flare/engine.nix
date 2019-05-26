{ stdenv, fetchFromGitHub, cmake, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf }:

stdenv.mkDerivation rec {
  pname = "flare-engine";
  version = "1.10";

  src = fetchFromGitHub {
    owner = "flareteam";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fm7jmxl86h8199nazdi9ivsrhcv9gcymhz1l5c6l2f4d0aqdqiq";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 SDL2_image SDL2_mixer SDL2_ttf ];

  meta = with stdenv.lib; {
    description = "Free/Libre Action Roleplaying Engine";
    homepage = "https://github.com/flareteam/flare-engine";
    maintainers = [ maintainers.aanderse ];
    license = [ licenses.gpl3 ];
    platforms = platforms.unix;
  };
}
