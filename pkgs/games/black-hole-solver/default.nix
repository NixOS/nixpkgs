{
  stdenv, lib, fetchurl,
  cmake, perl, pkg-config, python3,
  rinutils, PathTiny,
}:

stdenv.mkDerivation rec {
  pname = "black-hole-solver";
  version = "1.12.0";

  src = fetchurl {
    url = "https://fc-solve.shlomifish.org/downloads/fc-solve/${pname}-${version}.tar.xz";
    sha256 = "sha256-0y8yU291cykliPQbsNha5C1WE3bCGNxKtrrf5JBKN6c=";
  };

  nativeBuildInputs = [ cmake perl pkg-config python3 ];

  buildInputs = [ rinutils PathTiny ];

  prePatch = ''
    patchShebangs ./scripts
  '';

  meta = with lib; {
    description = "A solver for Solitaire variants Golf, Black Hole, and All in a Row";
    mainProgram = "black-hole-solve";
    homepage = "https://www.shlomifish.org/open-source/projects/black-hole-solitaire-solver/";
    license = licenses.mit;
  };
}
