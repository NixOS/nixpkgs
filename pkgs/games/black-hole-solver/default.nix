{
  stdenv, lib, fetchurl,
  cmake, perl, pkg-config, python3,
  rinutils, PathTiny,
}:

stdenv.mkDerivation rec {
  pname = "black-hole-solver";
  version = "1.10.1";

  meta = with lib; {
    homepage = "https://www.shlomifish.org/open-source/projects/black-hole-solitaire-solver/";
    description = "A solver for Solitaire variants Golf, Black Hole, and All in a Row.";
    license = licenses.mit;
  };

  src = fetchurl {
    url = "https://fc-solve.shlomifish.org/downloads/fc-solve/${pname}-${version}.tar.xz";
    sha256 = "1qhihmk4fwz6n16c7bnxnh3v7jhbb7xhkc9wk9484bp0k4x9bq9n";
  };

  nativeBuildInputs = [ cmake perl pkg-config python3 ];

  buildInputs = [ rinutils PathTiny ];

  prePatch = ''
    patchShebangs ./scripts
  '';

}
