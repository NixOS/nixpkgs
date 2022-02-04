{ lib, stdenv, fetchFromGitHub, cmake, SDL2, SDL2_mixer, libpng }:

stdenv.mkDerivation rec {
  pname = "augustus";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "Keriew";
    repo = "augustus";
    rev = "v${version}";
    sha256 = "1axm4x3ca5r08sv1b4q8y9c15mkwqd3rnc8k09a2fn3plbk2p2j4";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 SDL2_mixer libpng ];

  meta = with lib; {
    description = "An open source re-implementation of Caesar III. Fork of Julius incorporating gameplay changes";
    homepage = "https://github.com/Keriew/augustus";
    license = licenses.agpl3Only;
    platforms = platforms.all;
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ Thra11 ];
  };
}
