{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  name = "valkyrie-2.0.0";

  src = fetchurl {
    url = "http://valgrind.org/downloads/${name}.tar.bz2";
    sha256 = "0hwvsncf62mdkahwj9c8hpmm94c1wr5jn89370k6rj894kxry2x7";
  };

  buildInputs = [ qt4 ];

  configurePhase = "qmake PREFIX=$out";

  meta = {
    homepage = http://www.valgrind.org/;
    description = "Qt4-based GUI for the Valgrind 3.6.x series";

    license = "GPLv2";

    platforms = stdenv.lib.platforms.linux;
  };
}
