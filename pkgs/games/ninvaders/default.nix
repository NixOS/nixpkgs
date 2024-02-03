{ lib, stdenv, fetchFromGitHub, cmake, ncurses }:

stdenv.mkDerivation rec {
  pname = "ninvaders";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "sf-refugees";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wmwws1zsap4bfc2439p25vnja0hnsf57k293rdxw626gly06whi";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "Space Invaders clone based on ncurses";
    homepage = "https://ninvaders.sourceforge.net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ _1000101 ];
    platforms = platforms.all;
  };
}
