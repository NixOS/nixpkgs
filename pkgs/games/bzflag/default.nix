{ stdenv, lib, fetchurl, pkgconfig
, curl, SDL2, mesa, glew, ncurses, c-ares }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "bzflag";
  version = "2.4.8";

  src = fetchurl {
    url = "https://download.bzflag.org/${pname}/source/${version}/${name}.tar.bz2";
    sha256 = "08iiw0i0vx68d73hliiylswsm0nvnm849k37xc7iii6sflblvjj3";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ curl SDL2 mesa glew ncurses c-ares ];

  meta = with lib; {
    description = "Multiplayer 3D Tank game";
    homepage = http://bzflag.org/;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
