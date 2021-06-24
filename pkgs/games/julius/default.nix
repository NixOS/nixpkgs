{ lib, stdenv, fetchFromGitHub, cmake, SDL2, SDL2_mixer, libpng }:

stdenv.mkDerivation rec {
  pname = "julius";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "bvschaik";
    repo = "julius";
    rev = "v${version}";
    sha256 = "0nfdn8n6ywhm69ckz9a1chl5xxiqyaj3l337wadsbppnpscjihrc";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 SDL2_mixer libpng ];

  meta = with lib; {
    description = "An open source re-implementation of Caesar III";
    homepage = "https://github.com/bvschaik/julius";
    license = licenses.agpl3;
    platforms = platforms.all;
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ Thra11 ];
  };
}
