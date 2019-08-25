{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "flare-game";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "flareteam";
    repo = pname;
    rev = "v${version}";
    sha256 = "18m2qfbbaqklm20gnr7wzrwbmylp1jh781a4p1dq0hymqcg92x5l";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Fantasy action RPG using the FLARE engine";
    homepage = "https://github.com/flareteam/flare-game";
    maintainers = [ maintainers.aanderse ];
    license = [ licenses.cc-by-sa-30 ];
    platforms = platforms.unix;
  };
}
