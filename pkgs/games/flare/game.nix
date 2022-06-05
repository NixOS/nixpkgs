{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "flare-game";
  version = "1.13.04";

  src = fetchFromGitHub {
    owner = "flareteam";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7dEIagioM6OZXG+eNaYls8skHXSqGFXZuNhT0zhTFdY=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Fantasy action RPG using the FLARE engine";
    homepage = "https://github.com/flareteam/flare-game";
    maintainers = with maintainers; [ aanderse McSinyx ];
    license = [ licenses.cc-by-sa-30 ];
    platforms = platforms.unix;
  };
}
