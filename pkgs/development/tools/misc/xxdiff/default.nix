{ stdenv, fetchurl, qt4, flex, bison, docutils }:

stdenv.mkDerivation rec {
  name = "xxdiff-4.0";

  src = fetchurl {
    url = "mirror://sourceforge/xxdiff/${name}.tar.bz2";
    sha256 = "0c0k8cwxyv5byw7va1n9iykvypv435j0isvys21rkj1bx121al4i";
  };

  nativeBuildInputs = [ flex bison qt4 docutils ];

  buildInputs = [ qt4 ];

  QMAKE = "qmake";

  configurePhase = "cd src; make -f Makefile.bootstrap";

  installPhase = "mkdir -pv $out/bin; cp -v ../bin/xxdiff $out/bin";

  meta = {
    homepage = "http://furius.ca/xxdiff/";
    description = "Graphical file and directories comparator and merge tool";
    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [];
  };
}
