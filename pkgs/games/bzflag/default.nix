{ fetchurl, stdenv, curl, SDL, mesa, glew, ncurses }:

stdenv.mkDerivation rec {
  name = "bzflag-2.4.2";

  src = fetchurl {
    url = mirror://sourceforge/bzflag/bzflag-2.4.2.tar.bz2;
    sha256 = "04f8c83hfwwh4i74gxqqdbgc2r5hn9ayam986py3jjychhicaysg";
  };

  buildInputs = [ curl SDL mesa glew ncurses ];

  meta = {
    description = "Multiplayer 3D Tank game";
    homepage = http://bzflag.org/;
    license = stdenv.lib.licenses.lgpl21Plus;
  };
}
