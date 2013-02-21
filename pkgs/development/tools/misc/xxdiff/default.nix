{ stdenv, fetchhg, qt4, flex, bison }:

stdenv.mkDerivation {
  name = "xxdiff-4.0-beta1-20110723";

  src = fetchhg {
    name = "xxdiff";
    tag = "fdc247a7d9e5";
    url = https://hg.furius.ca/public/xxdiff;
    sha256 = "7ae7d81becc25b1adabc9383bb5b9005dddb31510cdc404ce8a0d6ff6c3dc47e";
  };

  nativeBuildInputs = [ flex bison qt4 ];

  buildInputs = [ qt4 ];

  QMAKE = "qmake";

  configurePhase =
    ''
      cd src
      make -f Makefile.bootstrap
    '';

  installPhase = "mkdir -pv $out/bin; cp -v ../bin/xxdiff $out/bin";
}
