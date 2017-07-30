{ stdenv, fetchFromGitHub, cmake
, glew, glm, mesa, libX11, libXext, libXrender, cppcheck, icu}:

stdenv.mkDerivation rec {
  name = "slop-${version}";
  version = "6.3.48";

  src = fetchFromGitHub {
    owner = "naelstrof";
    repo = "slop";
    rev = "v${version}";
    sha256 = "152xnisdbwx2zh1wzspy8djm937d1cm9zvcz1x22z8ia50ajm107";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ glew glm mesa libX11 libXext libXrender icu ]
                ++ stdenv.lib.optional doCheck cppcheck;

  doCheck = false;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Queries a selection from the user and prints to stdout";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with maintainers; [ primeos mbakke ];
  };
}
