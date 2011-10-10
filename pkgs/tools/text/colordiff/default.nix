{stdenv, fetchurl, perl /*, xmlto */}:

stdenv.mkDerivation {
  name = "colordiff-1.0.9";
  src = fetchurl {
    url = http://colordiff.sourceforge.net/colordiff-1.0.9.tar.gz;
    sha256 = "b2c25d81c10f22380798f146cc5b54ffc5aeb6e5ca1208be2b9508fec1d8e4a6";
  };

  buildInputs = [ perl /* xmlto */ ];
  dontBuild = 1; # do not build doc yet.
  installPhase = ''make INSTALL_DIR=/bin MAN_DIR=/share/man/man1 DESTDIR="$out" install'';
}
