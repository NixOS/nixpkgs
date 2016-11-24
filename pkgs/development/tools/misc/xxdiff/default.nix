{ stdenv, fetchurl, qt4, flex, bison, docutils }:

stdenv.mkDerivation rec {
  name = "xxdiff-4.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/xxdiff/${name}.tar.bz2";
    sha256 = "0050qd12fvlcfdh0iwjsaxgxdq7jsl70f85fbi7pz23skpddsn5z";
  };

  nativeBuildInputs = [ flex bison qt4 docutils ];

  buildInputs = [ qt4 ];

  QMAKE = "qmake";

  configurePhase = "cd src; make -f Makefile.bootstrap";

  installPhase = "mkdir -pv $out/bin; cp -v ../bin/xxdiff $out/bin";

  meta = with stdenv.lib; {
    homepage = http://furius.ca/xxdiff/;
    description = "Graphical file and directories comparator and merge tool";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
