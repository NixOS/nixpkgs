{ stdenv, fetchFromGitHub, cmake, pkgconfig
, glew, glm, libGLU, libGL, libX11, libXext, libXrender, icu
, cppcheck
}:

stdenv.mkDerivation rec {
  pname = "slop";
  version = "7.5";

  src = fetchFromGitHub {
    owner = "naelstrof";
    repo = "slop";
    rev = "v${version}";
    sha256 = "1k8xxb4rj2fylr4vj16yvsf73cyywliz9cy78pl4ibmi03jhg837";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ glew glm libGLU libGL libX11 libXext libXrender icu ]
                ++ stdenv.lib.optional doCheck cppcheck;

  doCheck = false;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Queries a selection from the user and prints to stdout";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with maintainers; [ primeos mbakke ];
  };
}
