{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "flare-game";
  version = "1.10";

  src = fetchFromGitHub {
    owner = "flareteam";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lfra4ww8za08vcgza2jvh3jrwi6zryk4ljyj32lpp9v4ws9hdh4";
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
