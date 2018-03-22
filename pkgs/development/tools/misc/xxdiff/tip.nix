{ stdenv, fetchFromBitbucket, qtbase, flex, bison, docutils }:

stdenv.mkDerivation rec {
  name = "xxdiff-401";

  src = fetchFromBitbucket {
    owner = "blais";
    repo = "xxdiff";
    rev = "5e5f885dfc43559549a81c59e9e8c9525306356a";
    sha256 = "0x954xinn91clf0v7bg4p5nx72lzy2jf6hzhx31zi2ff2v01p4qx";
  };

  nativeBuildInputs = [ flex bison docutils ];

  buildInputs = [ qtbase ];

  # Fixes build with Qt 5.9
  NIX_CFLAGS_COMPILE = [ "-std=c++11" ];

  preConfigure = ''
    cd src
    make -f Makefile.bootstrap
  '';

  postInstall = ''
    install -D ../bin/xxdiff $out/bin/xxdiff
  '';

  meta = with stdenv.lib; {
    homepage = http://furius.ca/xxdiff/;
    description = "Graphical file and directories comparator and merge tool";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub raskin ];
  };
}
