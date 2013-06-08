{ stdenv, fetchhg, qt4, flex, bison, docutils }:

stdenv.mkDerivation {
  name = "xxdiff-2013.03.08";

  src = fetchhg {
    name = "xxdiff";
    tag = "6a86d8353eef";
    url = https://hg.furius.ca/public/xxdiff;
    sha256 = "1c1krgmf1cfkrmg48w6zw61wgy01xm171ifkkh6givm8v6c8i340";
  };

  nativeBuildInputs = [ flex bison qt4 docutils ];

  buildInputs = [ qt4 ];

  QMAKE = "qmake";

  configurePhase =
    ''
      cd src
      make -f Makefile.bootstrap
    '';

  installPhase = "mkdir -pv $out/bin; cp -v ../bin/xxdiff $out/bin";

  meta.platforms = stdenv.lib.platforms.linux;

}
