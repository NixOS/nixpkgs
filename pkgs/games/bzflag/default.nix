{ fetchurl, stdenv, curl, SDL, mesa, glew, ncurses }:

stdenv.mkDerivation rec {
  name = "bzflag-2.0.16";

  src = fetchurl {
    url = mirror://sourceforge/bzflag/bzflag-2.0.16.tar.bz2;
    sha256 = "13v0ibiyq59j3xf23yf7s8blkmacagl8w48v2580k5bzkswa0vzy";
  };

  buildInputs = [ curl SDL mesa glew ncurses ];

  meta = {
    description = "Multiplayer 3D Tank game";
    homepage = http://bzflag.org/;
    license = "LGPLv2.1+";
  };
}
