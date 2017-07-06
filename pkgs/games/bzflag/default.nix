{ stdenv, lib, fetchurl, pkgconfig
, curl, SDL2, mesa, glew, ncurses, c-ares }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "bzflag";
  version = "2.4.10";

  src = fetchurl {
    url = "https://download.bzflag.org/${pname}/source/${version}/${name}.tar.bz2";
    sha256 = "1ylyd5safpraaym9fvnrqj2506dqrraaaqhrb2aa9zmjwi54aiqa";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ curl SDL2 mesa glew ncurses c-ares ];

  meta = with lib; {
    description = "Multiplayer 3D Tank game";
    homepage = https://bzflag.org/;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
