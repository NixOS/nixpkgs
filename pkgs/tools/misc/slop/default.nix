{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
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

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ glew glm libGLU libGL libX11 libXext libXrender icu ]
                ++ lib.optional doCheck cppcheck;

  doCheck = false;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Queries a selection from the user and prints to stdout";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
