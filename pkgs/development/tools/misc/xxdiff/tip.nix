{ stdenv, fetchFromBitbucket, qtbase, flex, bison, docutils }:

stdenv.mkDerivation rec {
  name = "xxdiff-4.0.1.20170623";

  src = fetchFromBitbucket {
    owner = "blais";
    repo = "xxdiff";
    rev = "5e5f885dfc43559549a81c59e9e8c9525306356a";
    sha256 = "0gbvxrkwkbvag3298j89smszghpr8ilxxfb0cvsknfqdf15b296w";
  };

  nativeBuildInputs = [ flex bison docutils ];

  buildInputs = [ qtbase ];

  preConfigure = ''
    ln -s ${qtbase.dev}/mkspecs/* ../__nix_qt*__/mkspecs
    ln -s ${qtbase.dev}/bin/* ../__nix_qt*__/bin || true
  '';

  NIX_CFLAGS_COMPILE="-I${qtbase.dev}/include/QtCore -I${qtbase.dev}/include/QtGui -I${qtbase.dev}/include/QtWidgets";
  
  configurePhase = "${preConfigure} cd src; make -f Makefile.bootstrap";

  installPhase = "mkdir -pv $out/bin; cp -v ../bin/xxdiff $out/bin";


  meta = with stdenv.lib; {
    homepage = http://furius.ca/xxdiff/;
    description = "Graphical file and directories comparator and merge tool";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub raskin ];
  };
}
