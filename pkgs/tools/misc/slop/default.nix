{ stdenv, fetchFromGitHub, cmake, pkgconfig
, glew, glm, libGLU_combined, libX11, libXext, libXrender, icu
, cppcheck
}:

stdenv.mkDerivation rec {
  name = "slop-${version}";
  version = "7.4";

  src = fetchFromGitHub {
    owner = "naelstrof";
    repo = "slop";
    rev = "v${version}";
    sha256 = "0fgd8a2dqkg64all0f96sca92sdss9r3pzmv5kck46b99z2325z6";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ glew glm libGLU_combined libX11 libXext libXrender icu ]
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
