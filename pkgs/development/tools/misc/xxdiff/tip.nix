{ stdenv, fetchFromBitbucket, qt5, flex, bison, docutils }:

stdenv.mkDerivation rec {
  name = "xxdiff-4.0.1.20170101";

  src = fetchFromBitbucket {
    owner = "blais";
    repo = "xxdiff";
    rev = "1cf6b23ad30a845daba28a3409c65f93aec7f5e8";
    sha256 = "0rq7grpndj85i7qzlj93jpzpfzk7bwsi55033fc63hb55rbdzz6z";
  };

  nativeBuildInputs = [ flex bison qt5.qtbase docutils ];

  buildInputs = [ qt5.qtbase ];

  preConfigure = ''
    ln -s ${qt5.qtbase.dev}/mkspecs/* ../__nix_qt*__/mkspecs
    ln -s ${qt5.qtbase.dev}/bin/* ../__nix_qt*__/bin || true
  '';

  NIX_CFLAGS_COMPILE="-I${qt5.qtbase.dev}/include/QtCore -I${qt5.qtbase.dev}/include/QtGui -I${qt5.qtbase.dev}/include/QtWidgets";
  
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
