{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "flare-game";
  version = "1.12rc1";

  src = fetchFromGitHub {
    owner = "flareteam";
    repo = pname;
    rev = "v${version}";
    sha256 = "1i2fa2hds5ph8gf5b9647vrn7ycz2fl9xaaaybz8yrjmnpx27bzc";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Fantasy action RPG using the FLARE engine";
    homepage = "https://github.com/flareteam/flare-game";
    maintainers = [ maintainers.aanderse ];
    license = [ licenses.cc-by-sa-30 ];
    platforms = platforms.unix;
  };
}
