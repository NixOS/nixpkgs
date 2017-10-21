{ stdenv, fetchurl, qt4, qmake4Hook }:

stdenv.mkDerivation rec {
  name = "valkyrie-2.0.0";

  src = fetchurl {
    url = "http://valgrind.org/downloads/${name}.tar.bz2";
    sha256 = "0hwvsncf62mdkahwj9c8hpmm94c1wr5jn89370k6rj894kxry2x7";
  };

  buildInputs = [ qt4 ];
  nativeBuildInputs = [ qmake4Hook ];

  meta = {
    homepage = http://www.valgrind.org/;
    description = "Qt4-based GUI for the Valgrind 3.6.x series";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    broken = true;
  };
}
