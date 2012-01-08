{ stdenv, fetchhg, qt4, flex, bison }:

stdenv.mkDerivation {
  name = "xxdiff-4.0-beta1-20110723";

  src = fetchhg {
    name = "xxdiff";
    url = https://hg.furius.ca/public/xxdiff;
    sha256 = "0ahx80vdf67vq9w0g66dx39y27gvz6v1aybqj9554n6vxvg1zk5n";
  };

  buildNativeInputs = [ flex bison qt4 ];

  buildInputs = [ qt4 ];

  QMAKE = "qmake";

  configurePhase =
    ''
      cd src
      make -f Makefile.bootstrap
    '';

  installPhase = "mkdir -pv $out/bin; cp -v ../bin/xxdiff $out/bin";
}
