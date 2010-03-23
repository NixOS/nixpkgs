{ stdenv, fetchurl, libpng }:

stdenv.mkDerivation rec {
  name = "pngnq-1.0";

  src = fetchurl {
    url = "mirror://sourceforge/pngnq/${name}.tar.gz";
    sha256 = "19q07hlhr9p5d0wqgzyrcxdnqlczdwpiibcji0k2a6jfmxrcn4rl";
  };

  buildInputs = [ libpng ];

  meta = {
    homepage = http://pngnq.sourceforge.net/;
    description = "A PNG quantizer";
    license = "bsd";
  };
}
