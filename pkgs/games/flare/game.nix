{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "flare-game";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "flareteam";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zfZTHw8obq5/z9+mCY0LIq9suvyh91ypqpxc3dNxI4o=";
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
