{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "flare-game";
  version = "1.12rc2";

  src = fetchFromGitHub {
    owner = "flareteam";
    repo = pname;
    rev = "v${version}";
    sha256 = "0k9fnbaqfgmih8bd0sh3kbk6f6v74i95wrbkij48gp48pq8yqbf9";
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
